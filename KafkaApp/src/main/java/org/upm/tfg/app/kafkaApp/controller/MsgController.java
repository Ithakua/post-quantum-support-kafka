package org.upm.tfg.app.kafkaApp.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.upm.tfg.app.kafkaApp.model.MessageBody;
import org.upm.tfg.app.kafkaApp.producer.KafkaProducer;

import lombok.RequiredArgsConstructor;


@RestController
// Ruta base para todos los endpoints
@RequestMapping("api/input/messages")
// Lombok genera un constructor para todos los campos
@RequiredArgsConstructor
public class MsgController {

	private final KafkaProducer producer;

	@PostMapping
	// Recibe un JSON con un body específico, lo envía a Kafka y devuelve una respuesta HTTP
	public ResponseEntity<String> sendMessage(@RequestBody MessageBody message){
		// Envía el mensaje a Kafka
		producer.sendMessage(message.getMessage());
		// Devuelve una respuesta HTTP 200 con un mensaje de éxito
		return ResponseEntity.ok("Message sended correctly!");
	}
}