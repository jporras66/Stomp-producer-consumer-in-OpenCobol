
STOMP PRODUCER & CONSUMER FOR ACTIVEMQ IN OPENCOBOL - Debian 6.0
================================================================

Hi. This is a small client for ActiveMQ-Stomp (producer & consumer)
write in OpenCobol that interfaces with Stomp trougth some c-routines.

My idea was to connect the examples with an IBM Host (z/os),
(MQSeries or ActiveMQ), and CICS as a TX Manager, and view how the solution scales.

Unfortunately I have no access to such a kind of machine to complete the test.
Peharps somebody could help me !!! :-) :-)

Hope you find it, usefull. Comments an ideas to improve it, will be welcomed.

		Regards. Javier (fjavier.porras@gmail.com) 

1. PreRequisites 
 
	1.1 OpenCobol v1.1- Installed and configured 
		
		-> Download :	http://www.opencobol.org/modules/mydownloads/singlefile.php?cid=1&lid=2
		-> Install  :   http://www.opencobol.org/modules/bwiki/index.php?InstallGuide
		
		Also GCC compiler and tools to compile and link
		
	1.2 Apache Portable Runtime Libararies and Headers (as root)
		
		# apt-get install libapr1 libapr1-dev
		# apt-get install libaprutil1 libaprutil1-dev 
		
	1.3 ActiveMQ last version and JRE needed
	
		->Download :	http://activemq.apache.org/activemq-560-release.html 
		->Install  :	http://activemq.apache.org/getting-started.html#GettingStarted-UnixBinaryInstallation

	1.4 Apache Ant (only needed for ActiveMQ examples)
	
		->Download & Install : http://ant.apache.org/manual/install.html

2.  Configure STOMP Transport for ActiveMQ

		Edit <activemq_path>/conf/activemq.xml

        <!--
		 <transportConnectors>
            <transportConnector name="openwire" uri="tcp://0.0.0.0:61616"/>
        </transportConnectors>
		-->
		
        <transportConnectors>
            <transportConnector name="openwire" uri="tcp://0.0.0.0:61616?jms.prefetchPolicy.all=1"/>
			<transportConnector name="stomp"    uri="stomp://localhost:61613?jms.prefetchPolicy.all=1"/>			
        </transportConnectors>					

		What jms.prefetchPolicy.all=1 menas ?
		-> http://activemq.apache.org/what-is-the-prefetch-limit-for.html
		
3.  Start Activemq and Test 

		Start :		<activemq_path>/bin/activemq start 
		Stop  :		<activemq_path>/bin/activemq stop  (under cygwin takes some seconds, because the script appears not to work properly) 
		
		Start Producer :	cd <activemq_path>/example ; ant producer
		Start Consumer :	cd <activemq_path>/example ; ant consumer
		
		Admin WEB Console:	hhtp://<your_serverip_here>:8161/admin/
		
4. Building Cobol Producer & Consumer

	4.0	To take in mind
		
		The Consumer is an slow client. Every message takes some seconds
		to be precessed before next queue-read.
		
		Stomp Protocol:
			-> http://stomp.github.com//stomp-specification-1.1.html
			
		Stomp behavior for C Objects and then, for Cobol Consumer
			SUBCRIBE
				id 						
					informed for a queue subscribed
				ack						
					client
				activemq.prefetchSize=1 
					Every Consumer fetch messages 1 by 1

			Reading from a Queue
				The message is acknowledged immediatly 
				
			Writing a Queue
				Every message is stored as binary, also text messages			
	
	4.1	Review  iniamqmng.sh
		-> Path to OpenCobol compiler
		-> DEBUG environment variable for trace display (C objects)
			if DEBUG=DEBUG -> Trace Display will be ON
			if DEBUG=NODEBUG (for example) -> Trace Display will be OFF
		
	4.2	Load  iniamqmng.sh
		$. iniamqmng.sh (or update your .bash_profile or .profile) 
		
	4.3 Build 

		Linux :	cd $APL ; make clean ; make all 
		cygwin:	cd $APL ; make -f makefile.cg clean ; make -f makefile.cg all 

4. Run Producer & Consumer

	->	cd $APL/brkcob :
		Usage:
		./producer <number_of_messages>  : number_of_messages PIC 9(4)
		./producer                       : generates by default 10 Messages
		
		Messages are created into /queue/TEST.FOO

		Sleeps 2 seconds between queue-reads		
			Review SECONDS-TO-SLEEP variable in producer.cob for time to wait.

        Every message is translated to EBCDIC and then enqueued
		
	->	cd $APL/brkcob
		./consumer 		
		
	    - if you want more than 1 consumer start consumer.sh 
		- Every message dequeued is:
			- write to a file (without changes, as dequeued)
			- converted to ascii
			- write to file again
			- Output file is pointed by exported environment variable FILEDATA.
			
