sed options 'command' file 
#########view file content##################
sed '' file.txt
sed -n 'np' file.txt    // print nth line from file.txt
sed -n '2p' file.txt
sed -n '3,10p' file.txt
sed -n '20,$p' file.txt
sed -n '12,+7p' file.txt
sed -n '4,$d' file.txt   // original file content is not deleting,only displaying time this will shows.
sed -n '10,12d' file.txt


Not: we used -n for suppressed the file bcoz we used -p for print and sed by default going to print thats why we used -n taaki print ho sake.

sed -i '10,$d' file.txt    // i for insert// this command changed our original file,delete line from 10 to last.
this will not show on terminal.


sed -i.backup '3,$d' file.txt  // this will change original file but also took backup before changing file.

ls -lrt
rwx---rw-------------file.txt
rwx-----r--------------file.txt.backup


#########searching file content##############

sed -n '/FS_CLUSTER_NAME/p' dev.sh  // to print all line which have having FS_/FS_CLUSTER/FS_CLUSTER_NAME
sed -n -e '/FS_/p' -e  '/AMI_TYPE/p' dev.sh // to print all line either having fs or AMI_TYTPE or both
sed -n "/$varible/p" file.txt  // double quotation is udes for print variable inside script
sed '10,$!d' file.txt // delete from 1 to 9 

sed 'echo/!d' file.txt  // except line with echo ,delete all lines but not changed original file.
sed -i 'echo/!d' file.txt   // except line with echo ,delete all lines ands also  changed original file // -i for permanent delete


########find and replace#################
#############for permanent find and replace use -i ########
sed '/old/new/' file

sed 's/root/udemy/' demo.sh   // change 1st word as a root of each lines to udemy
sed 's/root/uydemy/g' demo.sh   // globally changed // find all root word and replace with uydemy
sed 's/systemctl/daemon/2' demopass  // find 2nd word from all lines as systemctl and replace with daemon
sed '/devops/s/bash/ksh/' demopass  // search line starting from devops and then find bash and replace with ksh, its replace bash not devops

sed '/devops/s/bash/ksh/g' demopass // fro globally replace we used g options



############Insertion & Deletion############

sed '1i s_no salary' db.sh  // here i with any no indicated that you are going to insert befoe that no
o/p
s_no salary
1 pk 800
2 rk 899
3 ck 900

for permanent 
used -i // sed -i '1i s_no salary' db.sh
sed -i '1a ##################' db.sh 
sed -i '/ck/a 4 mk 500' db.sh
o/p
1 pk 800    // 1st line
##################   // 2nd line
%%%%%%%%%%%%     //3rd line
2 rk 899   // 4th
3 ck 900    //5th
4 mk 500   //6th

sed -i '3d' db.sh
o/p
	
1 pk 800
##################
2 rk 899
3 ck 900
4 mk 500

##########regular expression /pattern###############
pattern is a string represents more than one word
 
sed -n '/put/p' file.txt
sed -n '/p[uo]t/p' file.txt // put+pot

/s >> for space
sed -n '/\s/p' file.txt   // print line which contains space

\ // for Escape character
e.g sed -n '/\\s/p' shell.sh
\t // matches for tab  //         /s is a subset of \t
e.g sed -n '/\t/p' shell.sh

. // matches any char excluding new line
sed -n '/p.t/p' file.txt   // print all lines with p something t (e.g put,pat)
sed -n '/\sp.t/p' file.txt // print all lines with p something t (e.g put,pat) which contains space\

*  // zero,one or more than one of thi,this,thiss...
 sed -n '/this*/p' shell.sh
this+ // one or more than one // this,thiss,thisss...
sed -n '/this\+/p' shell.sh


\?  //   // zero or 1 time
 sed -n '/this\?/p' shell.sh

^ // charat // print lines starting with put 
sed -n '/^put/p' shell.sh

$ // dollor// line end with put
sed -n '/put$/p' shell.sh

empty line
sed -n '/^$/p' file.txt
sed -n '/^$/d' file.txt // delete empty lines

####### []#########Matches any character#########
[]
sed -n '/p[uo]t/p' file.txt // put+pot

sed -n '/p[u-o]t/p' file.txt // put+pot


2. {}  // Matches for required number of operations
sed -n '/this\{3\}/p' file .txt // print linex which contains exactly with three times s(sss e.g thisss)
sed -n '/this\{3,6\}/p'  // more than three times or 6 times
sed -n '/this\{3,\}/p' // >=3

3. ()  // This will search for zero or more sequence
sed -n '/\(asdf\)\{2\}/p' file.txt // print lines which contains two times asdf asdf

 


 







































