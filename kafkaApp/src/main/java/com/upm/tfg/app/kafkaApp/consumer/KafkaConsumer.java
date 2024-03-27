package com.upm.tfg.app.kafkaApp.consumer;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class KafkaConsumer {
	
	
	@KafkaListener(
			topics = "topicExample",
			groupId = "groupBetaV2")
	public void consumeMsg(String msg) {
		log.info(String.format("Consuming message from topic: %s", msg));
	}
	

}
