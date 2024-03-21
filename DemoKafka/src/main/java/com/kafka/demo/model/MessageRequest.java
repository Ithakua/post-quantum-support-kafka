package com.kafka.demo.model;

public class MessageRequest {

    private String message;
    
    public MessageRequest() {
    }

    public MessageRequest(String message) {
        this.message = message;
    }

    public String getMessage() {
        return this.message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
