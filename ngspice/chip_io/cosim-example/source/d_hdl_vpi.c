/*******************************************************************************
**        C/VPI SOURCE (c) 2015, SiliconReef
********************************************************************************
**
**        ID:      $Id: d_hdl_vpi.c,v 1.8 2016/01/08 19:59:33 gsr Exp gsr $
**        File:    d_hdl/d_hdl_vpi.c
**        Author:  Glenn Ramalho
**        Project: ADMS
**
********************************************************************************
**
**        Description: VPI Interface for d_hdl block
**
*******************************************************************************/

#include <vpi_user.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

/* MODE Indicators */
#define D_HDL_MODE_COMB 'C'
#define D_HDL_MODE_SYNC 'S'
#define D_HDL_MODE_ASYNC 'A'

struct s_simulatorinfo {
   int pipe_fd;
   int tohdlwidth;
   int tongspicewidth;
   int mode;
   PLI_INT32 clkval;
   vpiHandle clk_h;
   vpiHandle tohdl_h;
   vpiHandle tongspice_h;
};

struct s_startofsiminfo_t {
   char mode;
   vpiHandle systf_h;
};

void d_hdl_register();
int d_hdl_respond(int fd, char *buffer);
int d_hdl_getdeltatime(int mode, p_vpi_time time_s, unsigned long int ngspicetime);
int d_hdl_update(struct s_simulatorinfo *simulatorinfo_p);
PLI_INT32 d_hdl_compiletf(PLI_BYTE8 *user_data);
PLI_INT32 cb_hdl_startofsim(p_cb_data cb_data_p);
PLI_INT32 cb_hdl_clocktick(p_cb_data cb_data_p);
PLI_INT32 cb_hdl_endofcycle(p_cb_data cb_data_p);

/*******************************************************************************
 * CALL BACKS
 ******************************************************************************/
PLI_INT32 cb_hdl_startofsim(p_cb_data cb_data_p) {
   vpiHandle systf_h, arg_itr, pipe_h, cmd_h, clk_h, tohdl_h, tongspice_h;
   s_vpi_value argval;
   struct s_simulatorinfo *simulatorinfo_p;
   struct sockaddr_un pipeaddr;
   int socket_fd;
   int pipe_fd;
   int cpid;
   int returnval;
   char buffer[256];
   struct s_startofsiminfo_t *startofsiminfo_p;
   char mode;

   /* We start by grabbing the pipe name and creating it. */
   startofsiminfo_p = (struct s_startofsiminfo_t *)cb_data_p->user_data;
   systf_h = startofsiminfo_p->systf_h;
   mode = startofsiminfo_p->mode;
   arg_itr = vpi_iterate(vpiArgument, systf_h);
   pipe_h = vpi_scan(arg_itr);
   cmd_h = vpi_scan(arg_itr);
   tongspice_h = vpi_scan(arg_itr);
   tohdl_h = vpi_scan(arg_itr);
   if (mode == D_HDL_MODE_SYNC) clk_h = vpi_scan(arg_itr);
   else clk_h = NULL;
   vpi_free_object(arg_itr); /* We did not see NULL on arg_itr yet. */
   free(startofsiminfo_p); /* We do not need this either. */

   /* Now we can create the pipe. */
   argval.format = vpiStringVal;
   vpi_get_value(pipe_h, &argval);
   if (vpi_chk_error(NULL)) {
      vpi_printf("ERROR: $d_hdl() could not get the pipe filename\n");
      vpi_control(vpiFinish, 1);
      return 0;
   }

   /* We create the socket. */
   strncpy(pipeaddr.sun_path, argval.value.str, sizeof(pipeaddr.sun_path));
   pipeaddr.sun_path[sizeof(pipeaddr.sun_path)-1] = '\0';
   pipeaddr.sun_family = AF_UNIX;
   if (0 > (socket_fd = socket(AF_UNIX, SOCK_STREAM, 0))) {
      vpi_printf("ERROR: $d_hdl() could not open %s: %s\n",
	    argval.value.str, strerror(errno));
      vpi_control(vpiFinish, 1);
      return 0;
   }
   if (0 > bind(socket_fd, (struct sockaddr *)(&pipeaddr),
	    sizeof(struct sockaddr_un))) {
      vpi_printf("ERROR: $d_hdl(): bind failed: %s\n", strerror(errno));
      vpi_control(vpiFinish, 1);
      close(socket_fd);
      return 0;
   }
   if (0 > listen(socket_fd, 1)) {
      vpi_printf("ERROR: $d_hdl(): listen failed: %s\n", strerror(errno));
      close(socket_fd);
      return 0;
   }

   /* The socket is ready. We need to start the client now. */
   argval.format = vpiStringVal;
   vpi_get_value(cmd_h, &argval);
   if (vpi_chk_error(NULL)) {
      vpi_printf("ERROR: $d_hdl() could not get the pipe filename\n");
      vpi_control(vpiFinish, 1);
      return 0;
   }

   cpid = fork();
   if (cpid == -1) {
      vpi_printf("ERROR: $d_hdl(): failed to start the spice simulator: %s\n",
	    strerror(errno));
      vpi_control(vpiFinish, 1);
      return 0;
   }
   else if (cpid == 0) {
      /* If this is the child process we run the simulator. */
      returnval = system(argval.value.str);
      if (returnval == -1) exit(1);
      else exit(returnval);
   }
   else {
      /* Here we are at the master's side. We hang here until the HDL
       * simulator has made contact.  For some reason ModelSim dies here if
       * the other side fails to run. Ikarus does not have this problem.
       */
      if (0 > (pipe_fd = accept(socket_fd, NULL, NULL))) {
	 vpi_printf(
      "ERROR: $d_hdl(): failed to accept connection to other simulator: %s\n", 
            strerror(errno));
	 vpi_control(vpiFinish, 1);
	 close(socket_fd);
	 return 0;
      }

      /* We need to let the other simulator know the timeunit we are using. */
      sprintf(buffer, "TU=%0d", vpi_get(vpiTimeUnit, NULL));
      if (0 > write(pipe_fd, buffer, strlen(buffer))) {
	 vpi_printf(
	    "ERROR: $d_hdl(): failed to send data to other simulator: %s\n", 
            strerror(errno));
	 vpi_control(vpiFinish, 1);
	 return 0;
      }
      printf("Init Parameters: %s\n", buffer);

      /* Now we setup the struct that will be passed around the callbacks so
       * we can inform each function the parameters needed for the
       * communication.
       */
      if (NULL == (simulatorinfo_p = malloc(sizeof(struct s_simulatorinfo)))) {
	 vpi_printf(
	    "ERROR: $d_hdl(): failed to allocate memory for simulator info\n");
	 vpi_control(vpiFinish, 1);
	 return 0;
      }
      simulatorinfo_p->pipe_fd = pipe_fd;
      simulatorinfo_p->tohdlwidth = vpi_get(vpiSize, tohdl_h);
      simulatorinfo_p->tongspicewidth = vpi_get(vpiSize, tongspice_h);
      simulatorinfo_p->mode = mode;
      simulatorinfo_p->clkval = vpiX;
      simulatorinfo_p->clk_h = clk_h;
      simulatorinfo_p->tongspice_h = tongspice_h;
      simulatorinfo_p->tohdl_h = tohdl_h;

      /* We note it in the log that the mixed-mode simulation is ready
       * to begin.
       */
      vpi_printf(
	"d_hdl: Mixed mode simulation ready. Width to HDL=%0d Width to NGSPICE=%0d",
	 simulatorinfo_p->tohdlwidth, simulatorinfo_p->tongspicewidth);
      /* And we tell the HDL simulator to wait for the next data write. */
      d_hdl_update(simulatorinfo_p);
   }

   return 0;
}

PLI_INT32 cb_hdl_clocktick(p_cb_data cb_data_p) {
   s_cb_data cb_endofcycle_s;
   s_vpi_value value_s;
   s_vpi_time time_s;
   vpiHandle cb_h;
   struct s_simulatorinfo *simulatorinfo_p;

   /* The simulator info we get from the arguments. */
   simulatorinfo_p = (struct s_simulatorinfo *)cb_data_p->user_data;

   /* Now we tick the clock, the new value should be in the simulatorinfo
    * struct.
    */
   value_s.format = vpiScalarVal;
   value_s.value.scalar = simulatorinfo_p->clkval;
   vpi_put_value(simulatorinfo_p->clk_h, &value_s, NULL, vpiNoDelay);

   /* And we go to the end of the cycle so that we can send the updated
    * data back to the Analog side.
    */
   time_s.type = vpiSimTime;
   time_s.high = 0;
   time_s.low = 0;
   cb_endofcycle_s.reason = cbReadOnlySynch;
   cb_endofcycle_s.time = &time_s;
   cb_endofcycle_s.cb_rtn = cb_hdl_endofcycle;
   cb_endofcycle_s.obj = NULL;
   cb_endofcycle_s.value = NULL;
   cb_endofcycle_s.user_data = (PLI_BYTE8 *)simulatorinfo_p;
   cb_h = vpi_register_cb(&cb_endofcycle_s);
   vpi_free_object(cb_h);

   return 0;
}

PLI_INT32 cb_hdl_endofcycle(p_cb_data cb_data_p) {
   s_vpi_value value_s;
   char buffer[256];
   struct s_simulatorinfo *simulatorinfo_p;

   /* The simulator info we get from the arguments. */
   simulatorinfo_p = (struct s_simulatorinfo *)cb_data_p->user_data;

   /* First we get the value of the bus going to the analog domain and
    * we send it to the other side.
    */
   value_s.format = vpiBinStrVal;
   vpi_get_value(simulatorinfo_p->tongspice_h, &value_s);
   strncpy(buffer, value_s.value.str, 256);
   buffer[255] = '\0'; /* Just in case it was too wide. */

   /* And we send it to the other simulator. If it fails it can mean an error
    * occured or the other simulator simply finished.
    */
   if (0 < d_hdl_respond(simulatorinfo_p->pipe_fd, buffer)) return 0;

   /* And we wait for another update. */
   d_hdl_update(simulatorinfo_p);

   return 0;
}

/*******************************************************************************
 * Function: d_hdl_compiletf()
 *
 *  Checks all that can be checked for the $hdl system task at compilation
 *  time. Basically it will be just make sure that the block is connected to
 *  something that exists and is a valid.
 *
 * Returned value: NONE
 ******************************************************************************/

PLI_INT32 d_hdl_compiletf(PLI_BYTE8 *user_data) {
   vpiHandle systf_h, arg_itr, arg_h, cb_h;
   PLI_INT32 type;
   s_cb_data cb_startofsim_s;
   struct s_startofsiminfo_t *startofsiminfo_p;
   int argcnt;

   /* First we need the system task handle. */
   if (NULL == (systf_h = vpi_handle(vpiSysTfCall, NULL))) {
      vpi_printf("ERROR: could not get task handle\n");
      vpi_control(vpiFinish, 1);
      return 0;
   }

   /* Now, using it we get the arguments. */
   if (NULL == (arg_itr = vpi_iterate(vpiArgument, systf_h))) {
      vpi_printf("ERROR: $hdl requires two arguments: an OUT and an IN\n");
      vpi_control(vpiFinish, 1);
      return 0;
   }

   for (argcnt = 0; argcnt < 5; argcnt = argcnt + 1) {
      /* If this is not a synchronous mode line we skip the clock argument. */
      if (*(char *)user_data != D_HDL_MODE_SYNC && argcnt == 4) continue;

      /* Then we grab the argument handle. */
      if (NULL == (arg_h = vpi_scan(arg_itr))) {
	 vpi_printf(
 "ERROR: $hdl requires four arguments: filename, commandline, OUT and an IN\n");
	 /* No need to free the iterator as we reached the NULL, it is done for
	  * us.
	  */
	 vpi_control(vpiFinish, 1);
      }

      /* And we check it. */
      type = vpi_get(vpiType, arg_h);
      switch(argcnt) {
	 /* The first two arguments should be strings. The first one the file
	  * name and the second one the command to execute.
	  */
	 case 0:
	    if (type != vpiConstant
		  || vpi_get(vpiConstType, arg_h) != vpiStringConst) {
	       vpi_printf("ERROR: the first argument must be a file name\n");
	       vpi_free_object(arg_itr); /* No NULL yet, so free it. */
	       vpi_control(vpiFinish, 1);
	       return 0;
	    }
	    break;
	 case 1:
	    if (type != vpiConstant
		  || vpi_get(vpiConstType, arg_h) != vpiStringConst) {
	       vpi_printf("ERROR: the second argument must be a command\n");
	       vpi_free_object(arg_itr); /* No NULL yet, so free it. */
	       vpi_control(vpiFinish, 1);
	       return 0;
	    }
	    break;

	 /* Now we need the output signals, that means signals going from the
	  * HDL simulator to the XSPICE modules. Just about anything will work
	  * as we are just reading and passing to the other side, but type
	  * const does not make much sense.
	  */
	 case 2:
	    if (type != vpiReg && type != vpiIntegerVar && type != vpiNet) {
	       vpi_printf(
	"ERROR: the ToNGSPICE argument must be a reg or integer or wire type\n");
	       vpi_free_object(arg_itr); /* No NULL yet, so free it. */
	       vpi_control(vpiFinish, 1);
	       return 0;
	    }
	    break;
	 /* The last argument ha the inputs from XSPICE to HDL. That means we
	  * need to make sure we can drive a value on them. Therefore they must
	  * be of a type that can have multiple bits and can store a value, so
	  * no wires.
	  */
	 case 3:
	    if (type != vpiReg && type != vpiIntegerVar) {
	       vpi_printf(
	       "ERROR: the ToHDL argument must be type reg or integer : %d\n",
		  type);
	       vpi_free_object(arg_itr); /* No NULL yet, so free it. */
	       vpi_control(vpiFinish, 1);
	       return 0;
	    }
	    break;
	 /* This argument is for the clock. It only applies to the synchronous
	  * mode.
	  */
	 default:
	    if (type != vpiReg && type != vpiNet) {
	       vpi_printf(
	"ERROR: the CLK argument must be a reg or integer or wire type\n");
	       vpi_free_object(arg_itr); /* No NULL yet, so free it. */
	       vpi_control(vpiFinish, 1);
	       return 0;
	    }
	    break;
      }
   }

   /* Now we make sure we do not have too many arguments. */
   if (NULL != (arg_h = vpi_scan(arg_itr))) {
      vpi_printf(
"ERROR: $hdl requires four arguments: filename, commandline, OUT and an IN\n");
      vpi_free_object(arg_itr); /* We have not hit the NULL yet, so free it. */
      vpi_control(vpiFinish, 1);
   }

   /* Now we setup a callback to the start of simulation to start transfering
    * data.
    */
   if (NULL ==
	 (startofsiminfo_p = (struct s_startofsiminfo_t *)
	     malloc(sizeof(struct s_startofsiminfo_t)))) {
      vpi_printf(
	    "ERROR: $d_hdl(): failed to allocate memory for simulator info\n");
      vpi_control(vpiFinish, 1);
      return 0;
   }
   startofsiminfo_p->mode = *(char *)user_data;
   startofsiminfo_p->systf_h = systf_h;
   cb_startofsim_s.user_data = (PLI_BYTE8 *)startofsiminfo_p;
   cb_startofsim_s.reason = cbStartOfSimulation;
   cb_startofsim_s.cb_rtn = cb_hdl_startofsim;
   cb_startofsim_s.obj = NULL;
   cb_startofsim_s.time = NULL;
   cb_startofsim_s.value = NULL;
   cb_h = vpi_register_cb(&cb_startofsim_s);
   vpi_free_object(cb_h); /* And we dump the CB handle as we do not need it. */

   return 0;
}

/*******************************************************************************
 * Function: d_hdl_respond()
 *
 *  Returns signal updates to the other simulator.
 *
 * Returned value: 0 for success, nonzero for failure
 ******************************************************************************/

int d_hdl_respond(int fd, char *buffer) {
   if (0 >= write(fd, buffer, strlen(buffer))) {
      /* We then check errno to find out if we are simply finishing the
       * simulation or if there was a transmission error.
       */
      if (errno == EPIPE) {
	 vpi_printf("Simulation Finish Request");
	 vpi_control(vpiFinish, 0);
	 return 1;
      }
      else {
	 vpi_printf(
	    "ERROR: $d_hdl(): failed to send data to other simulator: %s\n", 
	    strerror(errno));
	 vpi_control(vpiFinish, 1);
	 return 2;
      }
   }
/*   printf("WE: >> %s <<\n", buffer); */
   return 0;
}

/*******************************************************************************
 * Function: d_hdl_getdeltatime()
 *
 *  Calculates the delta between the current HDL time and the time the
 *  analog domain went to.
 *
 * Returned value:
 *  0 for success, 1 for double trigger (time came out to zero) and 2 for
 *  negative time.
 ******************************************************************************/

int d_hdl_getdeltatime(int mode, p_vpi_time time_s,
      unsigned long int ngspicetime) {
   PLI_UINT32 lowtime, hightime;

   /* We start by checking the size of the variable to make sure we do not have
    * some odd machine where long int is size 32 bits or less. If we are at time
    * zero, we are at init, there is no delay to calculate.
    */

   if (sizeof(ngspicetime) <= 4) {
      if (ngspicetime < time_s->low) {
	 /* If time goes backwards we keep the assignment at the current time.*/
	 time_s->low = 0;
	 time_s->high = 0;
	 return 2;
      }
      else if (ngspicetime == time_s->low) {
	 time_s->low = 0;
	 time_s->high = 0;
	 if (ngspicetime != 0 && mode == D_HDL_MODE_SYNC) {
	    /* Double Trigger, meaning two triggers at the same time can be
	     * a problem for SYNC mode. Inital condition generates a false
	     * double trigger.
	     */
	    return 1;
	 }
      }
      else {
	 /* If time is valid, we replace time_s with the delta. */
	 time_s->low = ngspicetime - time_s->low;
	 time_s->high = 0;
	 return 0;
      }
   }
   else {
      /* This is the common case. We split the data into the VPI's 32/32 bit
       * format first. */
      lowtime = 0xffffffff & ngspicetime;
      hightime = ngspicetime >> 32;
      if ((hightime < time_s->high)
	    || ((hightime == time_s->high) && (lowtime < time_s->low)))
      {
	 /* If time goes backwards we keep the assignment at the current time.*/
	 time_s->low = 0;
	 time_s->high = 0;
	 return 2;
      }
      /* If time is valid, we replace time_s with the delta. */
      else if (lowtime < time_s->low) {
	 time_s->low = lowtime - time_s->low;
	 time_s->high = hightime - time_s->high - 1;
	 return 0;
      }
      else if (lowtime == time_s->low && hightime == time_s->high) {
	 time_s->low = 0;
	 time_s->high = 0;
	 if (ngspicetime != 0 && mode == D_HDL_MODE_SYNC) {
	    /* Double Trigger, meaning two triggers at the same time can be
	     * a problem for SYNC mode. Inital condition generates a false
	     * double trigger.
	     */
	    return 1;
	 }
      }
      else {
	 time_s->low = lowtime - time_s->low;
	 time_s->high = hightime - time_s->high;
	 return 0;
      }
   }

   return 0;
}

/*******************************************************************************
 * Function: d_hdl_update()
 *
 *  Blocks until data shows up from the other simulator, reads it, parses
 *  the line and schedules the data change. It then jumps to the next time
 *  step.
 *
 * Returned value:
 *  0 for success, non-zero for failure.
 ******************************************************************************/

int d_hdl_update(struct s_simulatorinfo *simulatorinfo_p) {
   s_cb_data cb_nextstep_s;
   vpiHandle cb_h;
   char buffer[256];
   char *assignstart;
   s_vpi_value value_s;
   unsigned long int ngspicetime;
   s_vpi_time time_s;
   int charsreceived;

   /* We need an infinite loop as sometimes we get multiple triggers and have
    * to then drop a few. The valid cases will exit with a return statement.
    */
   while(1) {
      /* We start by waiting for the data to arrive and grabbing it. */
      charsreceived = read(simulatorinfo_p->pipe_fd, buffer, 256);
      if (charsreceived == 0) {
	 /* If we read 0, it means the other side either died or closed the
	  * connection. We then quit nicely.
	  */
	 vpi_printf("Simulation Finish Request from NGSPICE Side\n");
	 vpi_control(vpiFinish, 0);
	 close(simulatorinfo_p->pipe_fd);
	 return 0;
      }
      else if (charsreceived < 0) {
	 /* A -1 indicates a transmission error. */
	 vpi_printf(
	       "ERROR: read() failed to get data from the other port: %s\n",
	       strerror(errno));
	 vpi_control(vpiFinish, 1);
	 close(simulatorinfo_p->pipe_fd);
	 return -1;
      }

      /* If we get anything else, then we simply process what came in. */
      if (charsreceived >= 256) buffer[255] = '\0';
      else buffer[charsreceived] = '\0';
      /* printf("Read: >> %s <<\n", buffer); */
      if (sscanf(buffer, "#%lu", &ngspicetime) <= 0) {
	 vpi_printf("ERROR: $d_hdl(): illegal format\n");
	 vpi_control(vpiFinish, 1);
	 close(simulatorinfo_p->pipe_fd);
	 return -1;
      }
      /* Now we can process the time. Note that it is given to us in absolute
       * value to reduce any slipping due to rounding errors. We do have to
       * convert it to a delta though as that is what Verilog needs. Therefore
       * we grab the current time, compare it to make sure it is not going
       * backwards, and store the final delta in the time_s struct.
       */
      time_s.type = vpiSimTime;
      vpi_get_time(NULL, &time_s);
      switch(d_hdl_getdeltatime(simulatorinfo_p->mode, &time_s, ngspicetime)) {
	 case 1:
	    vpi_printf(
	       "WARN: $d_hdl(): Double trigger at %lu\n", ngspicetime);
	       break;
	 case 2:
	    vpi_printf(
	     "WARN: $d_hdl(): Time getting out of sync. Analog: %lu HDL: %ld\n",
	       ngspicetime, ((PLI_UINT32)time_s.high) * (1UL<<32) + time_s.low);
      }

#ifdef D_HDL_BROKEN_CBREADWRITESYNCH
      /* Some systems have a broken cbReadWriteSynch.  We then have to subtract
       * a time unit, update the values, and then go to the intended place and
       * tick the clock. We don't do this at the initialization, of course, or
       * we will have a negative time. We also can't do this if the delta time
       * came to zero due to a double trigger.
       */
      if (simulatorinfo_p->mode == D_HDL_MODE_SYNC) {
	 if (ngspicetime != 0 && time_s.low == 0 && time_s.high == 0) {
	    if (0 < d_hdl_respond(simulatorinfo_p->pipe_fd, " ")) return 0;
	    else continue;
	 }
	 else if (time_s.low != 0) time_s.low = time_s.low - 1;
	 else if (time_s.high != 0) {
	    /* LOW wraps around and HIGH gets deducted one. */
	    time_s.low = time_s.low - 1;
	    time_s.high = time_s.high - 1;
	 }
      }
#endif

      /* Now we look for the assignments, if any */
      assignstart = strchr(buffer, ' ');
      if (assignstart != NULL) while(*assignstart == ' ') assignstart++;

      /* If we found something, we set the data. If there is a clock we
       * record it as we will set it later, to make sure the data gets latched
       * in this cycle. This is needed to keep us from adding a fake pipestage.
       */
      if (assignstart != NULL && *assignstart != '\0') {
	 /* If this is SYNC mode, the first bit is the clock. */
	 if (simulatorinfo_p->mode == D_HDL_MODE_SYNC) {
	    if (assignstart[0] == '0') simulatorinfo_p->clkval = vpi0;
	    else if (assignstart[0] == '1') simulatorinfo_p->clkval = vpi1;
	    else if (assignstart[0] == 'z') simulatorinfo_p->clkval = vpiZ;
	    else if (assignstart[0] == 'Z') simulatorinfo_p->clkval = vpiZ;
	    else simulatorinfo_p->clkval = vpiX;
	    assignstart = assignstart + 1;
	 }

	 /* Now, if we are dealing with the initial conditions, we simply set
	  * them accordingly.
	  */
	 if (ngspicetime == 0) {
	    time_s.type = vpiSimTime;
	    time_s.low = 0;
	    time_s.high = 0;
	    value_s.format = vpiBinStrVal;
	    value_s.value.str = assignstart;
	    vpi_put_value(simulatorinfo_p->tohdl_h, &value_s, &time_s,
		  vpiTransportDelay);
	    value_s.format = vpiScalarVal;
	    value_s.value.scalar = simulatorinfo_p->clkval;
	    vpi_put_value(simulatorinfo_p->clk_h, &value_s, &time_s,
		  vpiTransportDelay);
	 }

	 /* If this was not the initial conditions, we then need to follow the
	  * proper order. We then set the bus. The clock is set later. Note that
	  * we now have something in the time_s structure to look at.
	  */
	 else if (*assignstart != '\0') {
	    value_s.format = vpiBinStrVal;
	    value_s.value.str = assignstart;
	    vpi_put_value(simulatorinfo_p->tohdl_h,
		  &value_s, &time_s, vpiTransportDelay);
	 }
      }

      /* Now we setup a callback to the end of the time step when we set the
       * data bus. Then we can raise the clock or find out if there are any
       * outputs to grab. If there is no clock (or if this is the initial
       * conditions case) then we simply go to the end of the timestep, grab
       * the results, and send them to the Analog side.
       */
      if (ngspicetime == 0 || simulatorinfo_p->mode != D_HDL_MODE_SYNC) {
	 cb_nextstep_s.reason = cbReadOnlySynch;
	 cb_nextstep_s.time = &time_s;
	 cb_nextstep_s.cb_rtn = cb_hdl_endofcycle;
	 cb_nextstep_s.obj = NULL;
	 cb_nextstep_s.value = NULL;
	 cb_nextstep_s.user_data = (PLI_BYTE8 *)simulatorinfo_p;
	 cb_h = vpi_register_cb(&cb_nextstep_s);
	 vpi_free_object(cb_h);
      }

      /* For clocked interfaces in the normal flow, we need to tick the clock.
       * We then go to the end of the timestep, tick the clock, and then we can
       * do the returning data. Note that in some implementations (like Ikarus)
       * the cbReadOnlySynch does not wait until all cbReadWriteSynch callbacks
       * are done. Because of this any changes in the cbReadWriteSynch can be
       * missed by other callbacks, like the VCD dump task.
       */
      else {
#ifdef D_HDL_BROKEN_CBREADWRITESYNCH
	 /* If we are dealing with the broken cbReadWriteSynch, we then need to
	  * wait one time unit. In case of Double Triggers though we cannot do
	  * anything about it. Well the user has been warned.
	  */
	 cb_nextstep_s.reason = cbAfterDelay;
	 if (time_s.low == 0xffffffff) {
	    time_s.low = 0;
	    time_s.high = time_s.high + 1;
	 }
	 else time_s.low = time_s.low + 1;
#else
	 cb_nextstep_s.reason = cbReadWriteSynch;
#endif
	 cb_nextstep_s.time = &time_s;
	 cb_nextstep_s.cb_rtn = cb_hdl_clocktick;
	 cb_nextstep_s.obj = NULL;
	 cb_nextstep_s.value = NULL;
	 cb_nextstep_s.user_data = (PLI_BYTE8 *)simulatorinfo_p;
	 cb_h = vpi_register_cb(&cb_nextstep_s);
	 vpi_free_object(cb_h);
      }

      return 0;
   }

   return 0;
}

/*******************************************************************************
 * Function: d_hdl_register()
 *
 *  Registers the functions in the VPI object to the different system calls.
 *
 * Returned value: NONE
 ******************************************************************************/

void d_hdl_register() {
   s_vpi_systf_data tf_data;
   char d_hdl_mode_comb[] = {D_HDL_MODE_COMB};
   char d_hdl_mode_sync[] = {D_HDL_MODE_SYNC};
   char d_hdl_mode_async[] = {D_HDL_MODE_ASYNC};

   tf_data.type = vpiSysTask;
   tf_data.sysfunctype = 0;
   tf_data.calltf = NULL;
   tf_data.compiletf = d_hdl_compiletf;
   tf_data.sizetf = NULL;
   
   /* Depending on the task called we select a different argument. */
   tf_data.tfname = "$d_hdl_comb";
   tf_data.user_data = d_hdl_mode_comb;
   vpi_register_systf(&tf_data);

   tf_data.tfname = "$d_hdl_sync";
   tf_data.user_data = d_hdl_mode_sync;
   vpi_register_systf(&tf_data);

   tf_data.tfname = "$d_hdl_async";
   tf_data.user_data = d_hdl_mode_async;
   vpi_register_systf(&tf_data);
}
