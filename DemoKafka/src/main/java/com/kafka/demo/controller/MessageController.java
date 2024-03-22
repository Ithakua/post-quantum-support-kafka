package com.kafka.demo.controller;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kafka.demo.model.MessageRequest;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/message")
public class MessageController {
	
	private KafkaTemplate<String, String> kafkaTemplate;
	
	public MessageController(KafkaTemplate<String, String> kafkaTemplate) {
		this.kafkaTemplate = kafkaTemplate;
	}
	
	@PostMapping
	public void publish(@RequestBody MessageRequest request) {
		log.info(request.getMessage());
		kafkaTemplate.send("topic_uno", request.getMessage());
	}

}
