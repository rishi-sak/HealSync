package model;

public class Medicine {
    private String medicineName;
    private String startDate;
    private String endDate;
    private int dosageCount;
    private int id;
    private String dosageInstructions;
    private String reminderType;


    // Setter methods
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public void setDosageCount(int dosageCount) {
        this.dosageCount = dosageCount;
    }

    public void setId(int id){
        this.id = id;
    }

    public void setDosageInstructions(String dosageInstrucutions) {
        this.dosageInstructions = dosageInstrucutions;
    }

    public void setReminderType(String reminderType) {
        this.reminderType = reminderType;
    }

    // Getter methods (optional for now)
    public String getMedicineName() {
        return medicineName;
    }

    public String getStartDate() {
        return startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public int getDosageCount() {
        return dosageCount;
    }

    public String getDosageInstructions() {
        return dosageInstructions;
    }

    public String getRemindertype() {
        return reminderType;
    }

}
