#!/bin/sh
cat <<'EOT' > .gitignore
.DS_Store
*.vcd
*.raw
*.vvp
a.out
EOT
mkdir scripts		; echo "This folder contains miscelleneous useful scripts" > scripts/README.md 
mkdir def		; echo "This folder contains *.def files related to this project" > def/README.md 
mkdir gds		; echo "This folder contains *.gds files related to this project" > gds/README.md 
mkdir verilog		; echo "This folder contains *.v   files related to this project" > verilog/README.md 
mkdir mag		; echo "This folder contains *.mag files related to this project" > mag/README.md 
mkdir lef		; echo "This folder contains *.lef files related to this project" > lef/README.md 
mkdir macros		; echo "This folder contains subcell & macro files related to this project" > macros/README.md 
mkdir doc		; echo "This folder contains documents related to this project" > doc/README.md 
mkdir ngspice		; echo "This folder contains ngspice related files related to this project" > ngspice/README.md 
mkdir openlane		; echo "This folder contains openlane related files related to this project" > openlane/README.md 
mkdir pkg		; echo "This folder contains packaging-related files related to this project" > pkg/README.md
mkdir test		; echo "This folder contains test-related files related to this project" > test/README.md
mkdir xspice		; echo "This folder contains xspice files related to this project" > xspice/README.md
mkdir spi		; echo "This folder contains *.spi files related to this project" > spi/README.md
mkdir qflow		; echo "This folder contains qflow-related files related to this project" > qflow/README.md
