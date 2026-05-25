const API = "http://localhost:8081";

// CONTACTS
function loadContacts() {
    fetch(API + "/contacts")
    .then(res => res.json())
    .then(data => {
        let list = document.getElementById("contacts");
        list.innerHTML = "";

        data.forEach(c => {
            list.innerHTML += `
            <li>
                ${c.name} - ${c.phone}
                <button onclick="deleteContact(${c.id})">&#10060;</button>
            </li>`;
        });
    });
}

function addContact() {
    fetch(API + "/addContact", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            name: document.getElementById("name").value,
            phone: document.getElementById("phone").value
        })
    }).then(() => loadContacts());
}

function deleteContact(id) {
    fetch(API + "/contact/" + id, {method: "DELETE"})
    .then(() => loadContacts());
}

// CSV
function upload() {
    let file = document.getElementById("file").files[0];
    if (!file) {
        alert("Please select a file to upload.");
        return;
    }

    let form = new FormData();
    form.append("file", file);

    fetch(API + "/uploadContacts", {
        method: "POST",
        body: form
    })
    .then(res => {
        if (!res.ok) throw new Error("Upload failed");
        return res.text();
    })
    .then(data => {
        if (data === "Success") {
            alert("Upload successful");
            loadContacts();
        } else {
            alert("Upload failed: " + data);
        }
    })
    .catch(err => {
        console.error("ERROR:", err);
        alert("Failed to upload. Is the backend running?");
    });
}

// CAMPAIGN
function sendCampaign() {
    const message = document.getElementById("message").value;

    console.log("Sending message:", message); // DEBUG

    fetch(API + "/send", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            message: message,
            date: new Date().toLocaleString()
        })
    })
    .then(res => res.text()) // IMPORTANT FIX
    .then(data => {
        console.log("Response:", data);
        alert("Campaign sent!");
        loadCampaigns();
    })
    .catch(err => {
        console.error("ERROR:", err);
    });
}

function loadCampaigns() {
    fetch(API + "/campaigns")
    .then(res => res.json())
    .then(data => {
        let list = document.getElementById("campaigns");
        list.innerHTML = "";

        data.forEach(c => {
            list.innerHTML += `
            <li>
                ${c.message} - ${c.date}
                <button onclick="deleteCampaign(${c.id})">&#10060;</button>
            </li>`;
        });
    });
}

function deleteCampaign(id) {
    fetch(API + "/campaign/" + id, {method: "DELETE"})
    .then(() => loadCampaigns());
}

// INIT
loadContacts();
loadCampaigns();