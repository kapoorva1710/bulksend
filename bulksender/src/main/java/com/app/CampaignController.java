package com.app;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class CampaignController {

    @Autowired
    private CampaignRepository repo;

    @Autowired
    private ContactRepository contactRepo;

    @Autowired
    private SmsService smsService;

    // ✅ SEND CAMPAIGN (MAIN API)
    @PostMapping("/send")
    public Campaign sendCampaign(@RequestBody Campaign campaign) {

        System.out.println("=================================");
        System.out.println("[INFO] API HIT: /send");
        System.out.println("[INFO] Message: " + campaign.getMessage());

        List<Contact> contacts = contactRepo.findAll();

        System.out.println("[INFO] Total contacts: " + contacts.size());

        for (Contact c : contacts) {
            try {
                System.out.println("[INFO] Sending to: " + c.getPhone());

                smsService.sendSMS(c.getPhone(), campaign.getMessage());

            } catch (Exception e) {
                System.out.println("[ERROR] Failed for: " + c.getPhone());
                e.printStackTrace();
            }
        }

        System.out.println("=================================");

        // ✅ Save campaign in DB
        return repo.save(campaign);
    }

    // ✅ GET ALL CAMPAIGNS
    @GetMapping("/campaigns")
    public List<Campaign> getCampaigns() {
        return repo.findAll();
    }

    // ✅ DELETE CAMPAIGN
    @DeleteMapping("/campaign/{id}")
    public void deleteCampaign(@PathVariable Long id) {
        repo.deleteById(id);
    }
}