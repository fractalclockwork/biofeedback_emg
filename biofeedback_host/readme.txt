Biofeedback_EMG Release 1.0 
https://github.com/fractalclockwork/biofeedback

Instructions

1. Connect the signal wires from this sensor amplifer to the Ardunio board.
    A0 to RED/WHT (Ardunio Analog pin 0)
    GND to BLK (Ardunio signal ground)

2. Connect a 12v power supply to this sensor amplifier.

3. Connect the USB to a host computer.

4. Download biofeedback_emg into <path>:
	https://github.com/fractalclockwork/biofeedback

5. Install firmware to Ardunio
: (if need)
	download Ardunio tools: http://arduino.cc/en/Main/Software
	run <path>biofeedback_emg/biofeedback_client/biofeedback_client.ino 
	default serial speed is 115200
	send a char to received a line buffered response
	<samplePeriodInMicroSeconds, sampleAmplitude\n>

6. Run Display Application:
	download Processing tools: http://www.processing.org/download/
	run <path>biofeedback_emg/biofeedback_host/biofeedback_host.pde 

7. Finally, attach electrodes to skin.
	RED to mid-muscle
	WHT to end-muscle 
	BLK to a reference point on the elbow.
