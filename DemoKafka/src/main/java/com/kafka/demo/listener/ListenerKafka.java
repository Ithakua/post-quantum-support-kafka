package com.kafka.demo.listener;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

//Listener es el encargado de procesar los mensajes del API
@Component
public class ListenerKafka{
	
	@KafkaListener(
			topics = "topic_uno", 
			groupId = "foo")
	
	void listener (String data) {
		System.out.println("Listener received -> " + data );
	}

}
