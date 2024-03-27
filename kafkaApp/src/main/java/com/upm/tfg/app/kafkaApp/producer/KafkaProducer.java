package com.upm.tfg.app.kafkaApp.producer;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

//import static java.lang.String.format;

@Service
@RequiredArgsConstructor
@Slf4j
public class KafkaProducer {
	
	private final KafkaTemplate<String,String> kafkaTemplate;
	
	public void sendMessage(String msg) {
		log.info(String.format("Sending message to topic: %s" , msg));
		kafkaTemplate.send("topicExample", msg);
	}
	
}
