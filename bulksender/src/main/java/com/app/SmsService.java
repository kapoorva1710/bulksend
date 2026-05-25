package com.app;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class SmsService {

    private static final Logger log = LoggerFactory.getLogger(SmsService.class);

    @Value("${sms.gateway.url}")
    private String gatewayUrl;

    private final RestTemplate restTemplate;

    public SmsService() {
        this.restTemplate = new RestTemplate();
    }

    @Async
    public void sendSMS(String to, String msgText) {
        try {
            // Clean number: remove spaces, dashes, etc.
            String cleanNumber = to.replaceAll("[^0-9+]", "");

            // Add +91 country code if not present (Indian numbers)
            if (!cleanNumber.startsWith("+")) {
                if (cleanNumber.startsWith("91") && cleanNumber.length() == 12) {
                    cleanNumber = "+" + cleanNumber;
                } else {
                    cleanNumber = "+91" + cleanNumber;
                }
            }

            log.info("Sending SMS to: {}", cleanNumber);

            // RestSMS official API: POST with x-www-form-urlencoded
            // Keys: "phoneno" and "message"
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> payload = new LinkedMultiValueMap<>();
            payload.add("phoneno", cleanNumber);
            payload.add("message", msgText);

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(payload, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(gatewayUrl, request, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("✅ SMS sent to: {} - Response: {}", cleanNumber, response.getBody());
            } else {
                log.error("❌ SMS failed for: {} - Status: {} - Response: {}", cleanNumber, response.getStatusCode(), response.getBody());
            }

        } catch (Exception e) {
            log.error("❌ SMS exception for {}: {}", to, e.getMessage());
        }
    }
}
