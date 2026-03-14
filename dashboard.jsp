<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null || session.getAttribute("name") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String username = (String) session.getAttribute("name");
    List<Map<String, String>> todayMedicines = (List<Map<String, String>>) request.getAttribute("todayMedicines");
    List<Map<String, Object>> missedDoses = (List<Map<String, Object>>) request.getAttribute("missedDoses");
    String todayDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="refresh" content="70"> <!--Auto-refresh every 30 seconds-->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>HealSync Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
  <!--<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">-->
  <!--<link rel="stylesheet" href="styles.css">-->
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
    body { display: flex; height: 100vh; background: #f5f7fa; }
    .sidebar { width: 250px; background: #313a46; color: #fff; display: flex; flex-direction: column; padding: 20px; }
    .logo { font-size: 24px; font-weight: bold; margin-bottom: 40px; display: flex; align-items: center; gap: 10px; }
    .logo svg { width: 28px; height: 28px; }
    .nav a { color: #ddd; text-decoration: none; padding: 10px 0; transition: 0.3s; display: block; }
    .nav a:hover { color: #00c6ad; }
    .main { flex: 1; padding: 30px; animation: fadeIn 0.5s ease-in-out; overflow-y: auto; }
    .header { font-size: 24px; font-weight: 600; margin-bottom: 30px; }
    .cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
    .card { background: #ffffff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06); transition: transform 0.3s; }
    .card:hover { transform: translateY(-5px); }
    .card h3 { margin-bottom: 10px; font-size: 18px; color: #333; }
    .card p { color: #555; font-size: 14px; }
    .card-link { text-decoration: none; color: inherit; display: block; }
    .card-link:hover .card { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15); }
    .medicine-reminders { margin-top: 40px; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06); }
    .medicine-reminders h3 { margin-bottom: 10px; font-size: 18px; }
    #medicine-list li { margin-bottom: 6px; font-size: 15px; }
    .missed-doses { margin-top: 40px; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06); }
    .missed-doses h3 { margin-bottom: 10px; font-size: 18px; color: #c00; }
    .missed-doses li { margin-bottom: 6px; font-size: 15px; }
    .status-taken { color: green; font-weight: bold; }
    .status-skipped { color: red; font-weight: bold; }
    .status-missed { color: rgb(26, 33, 230); font-weight: bold; }
    @keyframes fadeIn { from {opacity: 0; transform: translateY(10px);} to {opacity: 1; transform: translateY(0);} }
    button { margin-left: 10px; padding: 8px 14px; border: none; border-radius: 6px; cursor: pointer; font-size: 15px; }
    .btn-taken { background: #28a745; color: #fff; }
    .btn-skip { background: #dc3545; color: #fff; }
  </style>
</head>
<body>
  <aside class="sidebar">
    <div class="logo">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4H8l4-4 4 4h-3v4z" />
      </svg>
      HealSync
    </div>
    <nav class="nav">
      <a href="Dashboard">Dashboard</a>
      <a href="AddMedicine.html">Add Medicine</a>
      <a href="my_medicines">View My Medicines</a>
      <a href="#">Missed Doses</a>
      <a href="#">PDF Report</a>
      <a href="logout">Logout</a>
    </nav>
  </aside>

  <main class="main"> 
    <div class="header">Welcome <%= username %> 👋</div>

    <div class="cards">
      <div class="card">
        <h3>Upcoming Doses</h3>
        <p>You have <%= todayMedicines != null ? todayMedicines.size() : 0 %> doses scheduled for today.</p>
      </div>
      <a href="AddMedicine.html" class="card-link">
        <div class="card">
          <h3>Add New Medicine</h3>
          <p>Click to schedule a new medicine reminder.</p>
        </div>
      </a>
      <a href="my_medicines" class="card-link">
        <div class="card">
          <h3>View My Medicines</h3>
          <p>See all your scheduled medicines in one place.</p>
        </div>
      </a>
      <div class="card">
        <h3>Missed Doses</h3>
        <p><%= missedDoses != null ? missedDoses.size() : 0 %> dose(s) missed today.</p>
      </div>
      <div class="card" onclick="window.location.href='PdfReportServlet'">
        <h3>Generate PDF Report</h3>
        <p>Download your dosage history.</p>
      </div>
        <div class="card" onclick="window.location.href='DoseHistoryServlet'">
        <h3>All Dose History</h3>
        <p>View all your taken, skipped, and missed doses.</p>
  </div>

    </div>

    <div class="medicine-reminders">
      <h3>Today's Medicines:</h3>
      <ul id="medicine-list">
        <% if (todayMedicines != null && !todayMedicines.isEmpty()) {
              for (Map<String, String> med : todayMedicines) { %>
            <li><%= med.get("name") %> at <%= med.get("time") %></li>
        <%   }
           } else { %>
            <li>No medicines scheduled for today.</li>
        <% } %>
      </ul>
    </div>

    <div class="missed-doses">
      <h3>Doses Status:</h3>
      <ul>
        <% if (missedDoses != null && !missedDoses.isEmpty()) {
              for (Map<String, Object> dose : missedDoses) {
                  String statusClass = "";
                  String status = (String) dose.get("status");
                  if ("TAKEN".equals(status)) statusClass = "status-taken";
                  else if ("SKIPPED".equals(status)) statusClass = "status-skipped";
                  else if ("MISSED".equals(status)) statusClass = "status-missed";
        %>
            <li class="<%= statusClass %>">
              <%= dose.get("name") %> at <%= dose.get("time") %> 
              (<%= dose.get("eventDate") %>) - <%= status %>
            </li>
        <%   }
           } else { %>
            <li>No missed doses today 🎉</li>
        <% } %>  
      </ul>
    </div>
  </main>
<script>
const todayMeds = [];
<% 
    if (todayMedicines != null && !todayMedicines.isEmpty()) {
        for (Map<String, String> med : todayMedicines) {
            String name = med.get("name");
            String time = med.get("time");
%>
    todayMeds.push({ name: '<%= name %>', time: '<%= time %>', notified: false, alarmTimeout: null, status: 'PENDING' });
<% 
        }
    }
%>

const alarmAudio = new Audio("sounds/alarm.mp3");
alarmAudio.volume = 1.0;

if (Notification.permission !== "granted") {
    Notification.requestPermission();
}

let currentMed = null;

// Popup
const popup = document.createElement("div");
popup.id = "medicinePopup";
popup.style.position = "fixed";
popup.style.top = "50%";
popup.style.left = "50%";
popup.style.transform = "translate(-50%, -50%)";
popup.style.padding = "20px 30px";
popup.style.backgroundColor = "#ffe6e6";
popup.style.color = "#800000";
popup.style.fontSize = "18px";
popup.style.fontWeight = "bold";
popup.style.borderRadius = "12px";
popup.style.boxShadow = "0 6px 12px rgba(0,0,0,0.3)";
popup.style.display = "none";
popup.style.zIndex = "9999";
popup.style.textAlign = "center";
document.body.appendChild(popup);

const popupMessage = document.createElement("span");
popup.appendChild(popupMessage);

// Mark as Taken button
const takenBtn = document.createElement("button");
takenBtn.innerText = "Mark as Taken";
takenBtn.className = "btn-taken";
popup.appendChild(takenBtn);

// Skip Medicine button
const skipBtn = document.createElement("button");
skipBtn.innerText = "Skip Medicine";
skipBtn.className = "btn-skip";
popup.appendChild(skipBtn);

// Event listeners for popup buttons
takenBtn.addEventListener("click", () => {
    stopAlarm();
    hidePopup();
    if (currentMed) {
        logDose(currentMed, "TAKEN");
        currentMed.status = "TAKEN"; // Update status in JS immediately
    }
});

skipBtn.addEventListener("click", () => {
    stopAlarm();
    hidePopup();
    if (currentMed) {
        logDose(currentMed, "SKIPPED");
        currentMed.status = "SKIPPED"; // Update status in JS immediately
    }
});

// Show / Hide popup
function showPopup(med) {
    popupMessage.innerHTML = `⏰ Time to take <b>${med.name}</b> now!`;
    popup.style.display = "block";
    currentMed = med;
}
function hidePopup() { popup.style.display = "none"; }
function stopAlarm() { 
    alarmAudio.pause(); 
    alarmAudio.currentTime = 0; 
}

// Log dose to backend
function logDose(med, status) {
    fetch("DoseServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "medicineName=" + encodeURIComponent(med.name) +
              "&medTime=" + encodeURIComponent(med.time) +
              "&status=" + status
    })
    .then(res => res.text())
    .then(data => {
        console.log("✅ Dose logged:", med.name, status);
        med.status = status; // ✅ update JS immediately
    })
    .catch(err => console.error("Error logging dose:", err));
}


// Trigger alarm for a medicine
// Check and trigger alarms every 5 seconds
function checkAndTriggerAlarms() {
    const now = new Date();
    const currentHour = now.getHours();
    const currentMinutes = now.getMinutes();

    todayMeds.forEach(med => {
        const [hour, minute] = med.time.split(":").map(Number);
        const nowMinutes = currentHour * 60 + currentMinutes;
        const medMinutes = hour * 60 + minute;

        // Trigger if time has passed and not yet notified, and status is PENDING
        if (medMinutes <= nowMinutes && !med.notified && med.status === "PENDING") {
            triggerAlarm(med);
            med.notified = true;
        }
    });
}
setInterval(checkAndTriggerAlarms, 5000);

// Trigger alarm for a medicine
function triggerAlarm(med) {
    alarmAudio.currentTime = 0;
    alarmAudio.play().catch(err => console.log("Alarm play failed:", err));
    showPopup(med);

    if (Notification.permission === "granted") {
        new Notification("⏰ Medicine Reminder", {
            body: `Time to take ${med.name} now!`,
            icon: "sounds/pill.png"
        });
    }

    // Auto-mark MISSED after 30s if no action
    med.alarmTimeout = setTimeout(() => {
        stopAlarm();
        hidePopup();
        if (med.status === "PENDING") { // only mark MISSED if still pending
            logDose(med, "MISSED");
            med.status = "MISSED"; // update JS
        }
    }, 30000);
}


// Mark as Taken function for table buttons
function markAsTaken(medicineName, medTime) {
    const med = todayMeds.find(m => m.name === medicineName && m.time === medTime);
    if (med) {
        med.status = "TAKEN"; // update JS immediately
    }

    fetch("DoseServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "medicineName=" + encodeURIComponent(medicineName) +
              "&medTime=" + encodeURIComponent(medTime) +
              "&status=TAKEN"
    })
    .then(res => console.log("✅ Dose logged via table button:", medicineName))
    .catch(err => console.error("Error:", err));
}

// Check and trigger alarms every 5 seconds
function checkAndTriggerAlarms() {
    const now = new Date();
    const currentHour = now.getHours();
    const currentMinutes = now.getMinutes();

    todayMeds.forEach(med => {
        const [hour, minute] = med.time.split(":").map(Number);
        if (hour === currentHour && minute === currentMinutes && !med.notified) {
            triggerAlarm(med);
            med.notified = true;
        }
    });
}
setInterval(checkAndTriggerAlarms, 5000);
</script>

</body>
</html>
