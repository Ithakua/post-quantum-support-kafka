package org.upm.tfg.app.kafkaApp.producer;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class KafkaProducer {

	private final KafkaTemplate<String,String> kafkaTemplate;

	// Este método recibe un mensaje, genera un log con el mensaje y lo envía al topic "topicExample"
	public void sendMessage(String msg) {
		log.info(String.format("Sending message to topic: %s" , msg));
		kafkaTemplate.send("topicExample", msg);
	}

}