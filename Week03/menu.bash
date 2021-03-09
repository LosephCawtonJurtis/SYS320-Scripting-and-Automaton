#!/bin/bash

# Story line: Menu for admin, VPN, and Security functions

function invalid_option() {

	echo ""
	echo "Invalid option"
	echo ""
	sleep 2
}

function delete_user() {
	clear
	read -p "what is the user's name?" name
	bash manage-users.bash -d -u "$name"
}

function check_user() {
	clear
	echo "if no output is given the user does not exist in wg0.conf file"
	read -p "what is the users name? " name
	grep $name /home/bash/sys320/wg0.conf | less
}

function menu() {

	# clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		1) admin_menu
		;;
		2) security_menu
		;;
		3) exit 0
		;;
			
		*)
		   invalid_option
			
		   # Call the main menu
		   menu

		;;


	esac

}

function admin_menu() {

	clear

	echo "[L]ist running processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l) ps -ef |less
		;;

		N|n) netstat -an --inet |less
		;;

		V|v) vpn_menu
		;;

		4) exit 0
		;;

		*)
			invalid_option
			admin_menu
		;;
	esac

admin_menu
}

function vpn_menu() {

	clear

	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[C]heck user"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "please enter an option: " choice

	case "$choice" in

		A|a) 
			bash peer.bash
			tail -6 wg0.conf |less
		;;
		D|d) # Create a prompt for the user
		     # call the manage-user.bash
		     #
		     delete_user
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		C|c) check_user
		;;
		E|e) exit 0
		;;
		*)
			invalid_option
			vpn_menu
		;;
	esac
vpn_menu

}

function security_menu() {

	clear

	echo "[L]ist open ports"
	echo "[C]heck user UIDs"
	echo "[S]ee last 10 logged in users"
	echo "[A]quire currently logged in users"
	echo "[E]xit"
	echo ""
	read -p "please enter an option" choice

	case "$choice" in

		L|l) 	ss -s|less
			ss -l |less
		;;
		C|c) cut -d: -f1,3 /etc/passwd |less
		;;
		S|s) lastlog |tail |less
		;;
		A|a) users |less
		;;
		E|e)	exit 0
		;;
		*) invalid_option
		;;

	esac

security_menu

}

menu
