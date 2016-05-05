# using Windows Subsystem for Linux
SHELL = /bin/bash

THEME_NAME = Windows\ 10
STF        = $(THEME_NAME).sublime-theme
NSTF       = $(STF).out
SSF        = Widget\ -\ $(THEME_NAME).sublime-settings
NSSF       = $(SSF).out

# accent colors
ACOL = (                                                           \
	[11]="255, 185, 0"   [12]="255, 140, 0"   [13]="247, 99, 12"   \
	[14]="202, 80, 16"   [15]="218, 59, 1"    [16]="239, 105, 80"  \
	[17]="209, 52, 56"   [18]="255, 67, 67"   [21]="231, 72, 86"   \
	[22]="232, 17, 35"   [23]="234, 0, 94"    [24]="195, 0, 82"    \
	[25]="227, 0, 140"   [26]="191, 0, 119"   [27]="194, 57, 179"  \
	[28]="154, 0, 137"   [31]="0, 120, 215"   [32]="0, 99, 177"    \
	[33]="142, 140, 216" [34]="107, 105, 214" [35]="135, 100, 184" \
	[36]="116, 77, 169"  [37]="177, 70, 194"  [38]="136, 23, 152"  \
	[41]="0, 153, 188"   [42]="45, 125, 154"  [43]="0, 183, 195"   \
	[44]="3, 131, 135"   [45]="0, 178, 148"   [46]="1, 133, 116"   \
	[47]="0, 204, 106"   [48]="16, 137, 62"   [51]="122, 117, 116" \
	[52]="93, 90, 88"    [53]="104, 118, 138" [54]="81, 92, 107"   \
	[55]="86, 124, 115"  [56]="72, 104, 96"   [57]="73, 130, 5"    \
	[58]="16, 124, 16"   [61]="118, 118, 118" [62]="76, 74, 72"    \
	[63]="105, 121, 126" [64]="74, 84, 89"    [65]="100, 124, 100" \
	[66]="82, 94, 84"    [67]="132, 117, 69"  [68]="126, 115, 95"  \
	[71]="41, 130, 204"                                            \
)
# default -> ACOL[31]
ACOL_DEFAULT = 0, 120, 215

.PHONY: all install uninstall clean

all: $(STF) $(SSF)

# .sublime-theme file
$(STF): ./templates/theme.json ./templates/theme_acol.json
	echo -ne "[\r\n" > $(NSTF)
	sed -e "s/@ACOL_DEFAULT/$(ACOL_DEFAULT)/" \
		./templates/theme.json >> $(NSTF)
	echo -ne "\r\n//==============================================================================\r\n" >> $(NSTF)
	echo -ne "// ACCENT COLORS\r\n" >> $(NSTF)
	echo -ne "//\r\n" >> $(NSTF)
	declare -A ACOLTMP=$(ACOL) ; \
	for ij in "$${!ACOLTMP[@]}" ; do \
		sed -e "s/@ACOLI/$$ij/" \
			-e "s/@ACOL/$${ACOLTMP[$${ij}]}/" \
			./templates/theme_acol.json >> $(NSTF) ; \
	done
	echo -ne "\r\n]\r\n" >> $(NSTF)
	mv -f $(NSTF) $(STF)

# .sublime-settings file
$(SSF): ./templates/settings.json
	echo -ne "{\r\n" > $(NSSF)
	sed -e "s/@THEME_NAME/$(THEME_NAME)/" \
		./templates/settings.json >> $(NSSF)
	echo -ne "\r\n}\r\n" >> $(NSSF)
	mv -f $(NSSF) $(SSF)

#install_path like "/mnt/c/Users/andre/AppData/Roaming/Sublime\ Text\ 3/Packages"
install: all install_path
	rm -rf $(shell cat install_path)/Theme\ -\ $(THEME_NAME).out/
	mkdir $(shell cat install_path)/Theme\ -\ $(THEME_NAME).out/
	cp -r * $(shell cat install_path)/Theme\ -\ $(THEME_NAME).out/
	rm -rf $(shell cat install_path)/Theme\ -\ $(THEME_NAME)/
	mv $(shell cat install_path)/Theme\ -\ $(THEME_NAME).out/ $(shell cat install_path)/Theme\ -\ $(THEME_NAME)/

uninstall: install_path
	rm -rf $(shell cat install_path)/Theme\ -\ $(THEME_NAME)/

installzip: all install_path
	zip -FSqr $(shell cat install_path)/Theme\ -\ $(THEME_NAME).sublime-package .[!.]* ..?* *

uninstallzip: install_path
	rm -f $(shell cat install_path)/Theme\ -\ $(THEME_NAME).sublime-package

clean:
	rm -rf $(STF) $(NSTF) $(SSF) $(NSSF)
