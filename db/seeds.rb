# Create a user
user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: true
)

# Create the Care template
care_template = Template.create!(
  name: 'Care',
  description: 'Template for Care EMR'
)

# Create domains for the Care template
care_domains = [ "care.ohc.network", "care.do.ohc.network" ]

care_domains.each do |fqdn|
  Domain.create!(
    template: care_template,
    fqdn: fqdn,
    archived: false
  )
end

# Create the Medispeak template
medispeak_template = Template.create!(
  name: 'Medispeak',
  description: 'Medispeak demo EMR'
)

demo_app_domains = [ "localhost:5173", "www.medispeak.in" ]

demo_app_domains.each do |fqdn|
  Domain.create!(
    template: medispeak_template,
    fqdn: fqdn,
    archived: false
  )
end

# Create pages for the Care template
consultation_form = Page.create!(
  template: care_template,
  name: 'Consultation Form'
)

log_update = Page.create!(
  template: care_template,
  name: 'Log Update'
)

# Create page for the Medispeak template
medispeak_demo_page = Page.create!(
  template: medispeak_template,
  name: 'Demo Page 1'
)

# Create form fields for the Consultation Form page (Care template)
consultation_form_fields = [
  {
    title: "history_of_present_illness",
    friendly_name: "History of Present Illness",
    description: "Details about the current illness, including when",
    field_type: "string"
  },
  {
    title: "examination_details",
    friendly_name: "Examination Details",
    description: "Details about the examination performed and clinic",
    field_type: "string"
  },
  {
    title: "weight",
    friendly_name: "Weight",
    description: "The patient's weight, usually measured in kilogram",
    field_type: "number",
    minimum: 0,
    maximum: 500
  },
  {
    title: "height",
    friendly_name: "Height",
    description: "The patient's height, usually measured in centimeters",
    field_type: "number",
    minimum: 0,
    maximum: 300
  },
  {
    title: "consultation_notes",
    friendly_name: "Consultation Notes",
    description: "General Advice given to the patient",
    field_type: "string"
  },
  {
    title: "special_instruction",
    friendly_name: "Special Instructions",
    description: "Any special instructions for the patient or other",
    field_type: "string"
  },
  {
    title: "treatment_plan",
    friendly_name: "Treatment Plan",
    description: "Treatment plan for the patient, including prescriptions",
    field_type: "string"
  },
  {
    title: "patient_no",
    friendly_name: "Patient Number",
    description: "The inpatient or out patient number assigned to the patient",
    field_type: "string"
  }
]

# Create form fields for the Log Update page (Care template)
log_update_fields = [
  {
    title: "physical_examination_info",
    friendly_name: "Physical Examination Info",
    description: "Physical Examination Details, including any complaints",
    field_type: "string"
  },
  {
    title: "other_details",
    friendly_name: "Other Details",
    description: "Other details, including Treatment Plans, Advice",
    field_type: "string"
  },
  {
    title: "diastolic",
    friendly_name: "Diastolic BP",
    description: "Blood Pressure Diastolic as integer",
    field_type: "number",
    minimum: 0,
    maximum: 200
  },
  {
    title: "systolic",
    friendly_name: "Systolic BP",
    description: "Blood Pressure Systolic as integer",
    field_type: "number",
    minimum: 0,
    maximum: 300
  },
  {
    title: "temperature",
    friendly_name: "Temperature",
    description: "Temperature in Fahrenheit",
    field_type: "number",
    minimum: 90,
    maximum: 110
  },
  {
    title: "resp",
    friendly_name: "Respiratory Rate",
    description: "Respiratory Rate as integer",
    field_type: "number",
    minimum: 0,
    maximum: 100
  },
  {
    title: "spo2",
    friendly_name: "SPO2",
    description: "SPO2 Value as integer",
    field_type: "number",
    minimum: 0,
    maximum: 100
  },
  {
    title: "pulse",
    friendly_name: "Pulse Rate",
    description: "Pulse Rate as integer",
    field_type: "number",
    minimum: 0,
    maximum: 300
  }
]

# Create form fields for the Demo Page 1 (Medispeak template)
medispeak_demo_fields = [
  {
    title: "gender",
    friendly_name: "Gender",
    description: "Gender from options Male, Female, Other",
    field_type: "single_select",
    enum_options: ["Male", "Female", "Other"]
  },
  {
    title: "symptoms",
    friendly_name: "Symptoms",
    description: "Applicable Symptoms from options",
    field_type: "multi_select",
    enum_options: ["Headache", "Fever", "Cough", "Cold", "Body Pain"]
  },
  {
    title: "preferred_time",
    friendly_name: "Preferred Time",
    description: "The Preferred Time from the options",
    field_type: "single_select",
    enum_options: ["Morning", "Afternoon", "Evening"]
  },
  {
    title: "full_name",
    friendly_name: "Full Name",
    description: "Full name",
    field_type: "string"
  },
  {
    title: "age",
    friendly_name: "Age",
    description: "Age of the user",
    field_type: "number",
    minimum: 0,
    maximum: 150
  },
  {
    title: "email",
    friendly_name: "Email",
    description: "Email of the user",
    field_type: "string"
  },
  {
    title: "phone_number",
    friendly_name: "Phone Number",
    description: "Phone Number of the user",
    field_type: "string"
  },
  {
    title: "additional_notes",
    friendly_name: "Additional Notes",
    description: "Full text of the conversation",
    field_type: "string"
  },
  {
    title: "date_of_birth",
    friendly_name: "Date of Birth",
    description: "Date of Birth as a Javascript Date String",
    field_type: "string"
  }
]

# Update the creation loops to include all attributes
[
  [consultation_form, consultation_form_fields],
  [log_update, log_update_fields],
  [medispeak_demo_page, medispeak_demo_fields]
].each do |page, fields|
  fields.each do |field_data|
    FormField.create!(
      page: page,
      title: field_data[:title],
      friendly_name: field_data[:friendly_name],
      description: field_data[:description],
      field_type: field_data[:field_type],
      minimum: field_data[:minimum],
      maximum: field_data[:maximum],
      enum_options: field_data[:enum_options]
    )
  end
end

puts "Seeds created successfully!"
puts "User email: #{user.email}"
puts "Care Template: #{care_template.name}"
puts "Medispeak Template: #{medispeak_template.name}"
puts "Total Domains created: #{Domain.count}"
puts "Total Pages created: #{Page.count}"
puts "Form fields created for Consultation Form: #{consultation_form.form_fields.count}"
puts "Form fields created for Log Update: #{log_update.form_fields.count}"
puts "Form fields created for Medispeak Demo Page 1: #{medispeak_demo_page.form_fields.count}"
