import re
import sys



if __name__ == '__main__':

    arguments = []
    optionlist = []

    for option in sys.argv[1:]:
        if option.find('-', 0) == 0:
            optionlist.append(option)
        else:
            arguments.append(option)

    if len(arguments) == 0:
        print("please pass the sdf file path")
        sys.exit(0)

    sdf_file = arguments[0]
    file1 = open(sdf_file, 'r')
    count = 0
    
    new_lines = []
    while True:
        count += 1
    
        # Get next line from file
        line = file1.readline()
    
        # if line is empty
        # end of file is reached
        if not line:
            break

        result1 = re.search(r".*\((\d*\.?\d*)::(\d*\.?\d*)\).*\((\d*\.?\d*)::(\d*\.?\d*)\)", line)
        result2 = re.search(r".*\((\-?\d*\.?\d*)::(\-?\d*\.?\d*)\)", line)

        if result1:
            group1 = result1.group(1)
            group2 = result1.group(2)
            group3 = result1.group(3)
            group4 = result1.group(4)

            avg1 = (float(group1) + float(group2)) / 2.00 
            avg2 = (float(group2) + float(group3)) / 2.00 

            x = line.replace("::", f":{avg1}:")
            y = x.replace("::", f":{avg2}:")
            new_lines.append(y)
        elif result2:
            group1 = result2.group(1)
            group2 = result2.group(2)
            avg1 = (float(group1) + float(group2)) / 2.00 
            x = line.replace("::", f":{avg1}:")
            new_lines.append(x)
        else:  
            new_lines.append(line)

    file1.close()

    # write file 
    a_file = open(sdf_file, "w")
    a_file.writelines(new_lines)
    a_file.close()
