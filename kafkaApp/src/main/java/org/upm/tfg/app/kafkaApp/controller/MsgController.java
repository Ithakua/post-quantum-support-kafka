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
@RequestMapping("api/v2/messages")
@RequiredArgsConstructor
public class MsgController {
	
	private final KafkaProducer producer;
	
	@PostMapping
	public ResponseEntity<String> sendMessage(@RequestBody MessageBody message){
		producer.sendMessage(message.getMessage());
		return ResponseEntity.ok("Message sended correctly!");
	}
	

}
