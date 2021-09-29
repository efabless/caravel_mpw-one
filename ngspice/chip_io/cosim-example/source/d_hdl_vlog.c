/* VPI Registry */
extern void d_hdl_register();

void (*vlog_startup_routines[])() = {
   d_hdl_register,
   0
};
