package com.app;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@CrossOrigin
public class ContactController {

    @Autowired
    private ContactRepository repo;

    @PostMapping("/addContact")
    public Contact addContact(@RequestBody Contact c) {
        return repo.save(c);
    }

    @GetMapping("/contacts")
    public List<Contact> getAll() {
        return repo.findAll();
    }

    @DeleteMapping("/contact/{id}")
    public void delete(@PathVariable Long id) {
        repo.deleteById(id);
    }

    @PostMapping("/uploadContacts")
    public String upload(@RequestParam("file") MultipartFile file) {
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream()));
            String line;
            int savedCount = 0;

            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                line = line.replace("\"", "");

                String[] data = line.split(",");
                if (data.length < 2) data = line.split(";");
                if (data.length < 2) data = line.split("\t");

                Contact c = new Contact();
                if (data.length >= 2) {
                    c.setName(data[0].trim());
                    c.setPhone(data[1].trim());
                } else if (data.length == 1) {
                    c.setName("Unknown");
                    c.setPhone(data[0].trim());
                } else {
                    continue;
                }

                repo.save(c);
                savedCount++;
                System.out.println("Saved: " + c.getName());
            }

            if (savedCount == 0) {
                return "Error: No valid contacts found in the file.";
            }

            return "Success";
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}

