package com.recruitment.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * POJO representing a job application.
 * Maps to the 'applications' table.
 */
public class Application implements Serializable {
    private static final long serialVersionUID = 1L;

    private int applicationId;
    private int vacancyId;
    private int candidateId;
    private String coverLetter;
    private String cvSnapshotPath;
    private String status; // APPLIED, UNDER_REVIEW, SHORTLISTED, REJECTED, HIRED, WITHDRAWN
    private String recruiterNotes;
    private Timestamp appliedAt;
    private Timestamp updatedAt;

    // Joined fields for display
    private String jobTitle;
    private String companyName;
    private String candidateName;
    private String candidateEmail;
    private String candidatePhone;
    private String candidateCvPath;
    private String vacancyLocation;
    private String employmentType;

    public Application() {}

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public int getVacancyId() {
        return vacancyId;
    }

    public void setVacancyId(int vacancyId) {
        this.vacancyId = vacancyId;
    }

    public int getCandidateId() {
        return candidateId;
    }

    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }

    public String getCoverLetter() {
        return coverLetter;
    }

    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }

    public String getCvSnapshotPath() {
        return cvSnapshotPath;
    }

    public void setCvSnapshotPath(String cvSnapshotPath) {
        this.cvSnapshotPath = cvSnapshotPath;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRecruiterNotes() {
        return recruiterNotes;
    }

    public void setRecruiterNotes(String recruiterNotes) {
        this.recruiterNotes = recruiterNotes;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCandidateName() {
        return candidateName;
    }

    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }

    public String getCandidateEmail() {
        return candidateEmail;
    }

    public void setCandidateEmail(String candidateEmail) {
        this.candidateEmail = candidateEmail;
    }

    public String getCandidatePhone() {
        return candidatePhone;
    }

    public void setCandidatePhone(String candidatePhone) {
        this.candidatePhone = candidatePhone;
    }

    public String getCandidateCvPath() {
        return candidateCvPath;
    }

    public void setCandidateCvPath(String candidateCvPath) {
        this.candidateCvPath = candidateCvPath;
    }

    public String getVacancyLocation() {
        return vacancyLocation;
    }

    public void setVacancyLocation(String vacancyLocation) {
        this.vacancyLocation = vacancyLocation;
    }

    public String getEmploymentType() {
        return employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }
}
