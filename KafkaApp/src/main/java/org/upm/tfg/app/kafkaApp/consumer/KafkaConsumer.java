package org.upm.tfg.app.kafkaApp.consumer;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
// La anotación @Slf4j de Lombok genera un logger
@Slf4j
public class KafkaConsumer {

	// La anotación @KafkaListener indica que este método es un oyente de Kafka que consume mensajes del tema "topicExample"
	@KafkaListener(
			topics = "topicExample", // Topic Kafka del que se consumen los mensajes
			groupId = "groupBetaV2") // ID del grupo de consumidores de Kafka

	// Método que se invoca cuando Kafka recibe un mensaje del topic
	public void consumeMsg(String msg) {
		// Se procesa el mensaje recibido generando un log en este caso
		log.info(String.format("Consuming message from topic: %s", msg));
	}
}