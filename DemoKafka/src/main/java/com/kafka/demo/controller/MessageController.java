package com.kafka.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kafka.demo.model.MessageRequest;

@RestController
@RequestMapping("/api/message")
public class MessageController {
	
    private static final Logger log = LoggerFactory.getLogger(MessageController.class);
	
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
