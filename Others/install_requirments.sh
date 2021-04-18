#! /bin/bash


# For centos 7

package=$1


basic_deps () {

	echo "Install basic deps"
	sleep 1	
	deps="cmake"
	
	yum install cmake
}


install_epel_repos () {

	echo "Add epel repository"
	yum install -y epel-release

}

install_pip () {
	echo "Install pip (python 2 based)"
	sleep 1
	yum install -y python-pip

	echo "upgrade pip"
	sleep 1
	pip install --upgrade pip
}

install_pip3 () {
	echo "Install pip3 (python3 based)"
	echo "Add /usr/local/bin to /etc/sudoers command line path"
	sleep 1
	python3 -m ensurepip

}

install_meson () {
	echo "install google meson"
	sleep 1

	echo "dependent on pip3, confirm it's installed."	
	install_pip3	

	pip3 install meson	
}

install_sshfs () {

	echo "depends on meson"
	install_meson

	ins_path="~/Installers/"

	echo "git clone sshfs source code"
	mkdir -p ${ins_path}
	git clone git@github.com:libfuse/sshfs.git  ${ins_path}

	cd ${ins_path}
	mkdir -p build
	cd build
	meson ..
}

install_supermin () {
	echo "install supermin5 & make a symbol link"
	sleep 1
	
	yum install -y supermin5 supermin5-devel
	sleep 1

	ins_path=`which supermin5`
	rm /usr/bin/supermin
	ln -s ${ins_path} /usr/bin/supermin

}


install_qemu_kvm () {
	
	echo "install the centos qemu-kvm"
	sleep 1

	yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install

}

install_guestfs () {

	echo "Install depdents"
	sleep 1
	deps="libconfig libconfig-devel ocaml ocaml-ocamlbuild ocaml-ocamlbuild-devel ocaml-findlib ocaml-hivex ocaml-hivex-devel  acl libacl  libacl-devel file-devel fuse fuse-devel hivex hivex-devel  autoconf automake libtool gettext-devel genisoimage augeas augeas-devel file-devel jansson jansson-devel jansson-devel-doc  "
	yum install -y ${deps}
	install_supermin	
	install_qemu_kvm

	echo "Install from github"	
	sleep 1
	ins_path="~/Installers/"
	mkdir -p ${ins_path}

	git clone git@github.com:libguestfs/libguestfs.git ${ins_path}
	cd ${ins_path}/libguestfs
	./autogen.sh
}


###
### Check the parameters
###

if [ -z "${package}"  ]
then
	echo "Choose the package to install : guestfs, sshfs, qemu-kvm"
	read package
else
	echo "Install the dependents for package : ${package}" 
fi


###
###  Do the action
###

if [ "${package}" = "guestfs"  ]
then

	install_guestfs

elif [ "${package}" = "sshfs"  ]
then
	basic_deps
	install_sshfs	

elif [ "${package}" = "qemu-kvm" ]
then
	
	install_qemu_kvm

elif [ "${package}" = "test"  ]
then	
	install_supermin

else
	echo "NOT support package ${package}"
	exit 0
fi

sudo yum install ${deps} 
