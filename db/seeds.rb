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
care_domains = ["care.ohc.network", "care.do.ohc.network"]

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

demo_app_domains = ["localhost:3000", "www.medispeak.in"]

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
  { title: "history_of_present_illness", description: "Details about the current illness, including when" },
  { title: "examination_details", description: "Details about the examination performed and clinic" },
  { title: "weight", description: "The patient's weight, usually measured in kilogram" },
  { title: "height", description: "The patient's height, usually measured in centimet" },
  { title: "consultation_notes", description: "General Advice given to the patient" },
  { title: "special_instruction", description: "Any special instructions for the patient or other" },
  { title: "treatment_plan", description: "Treatment plan for the patient, including prescrib" },
  { title: "patient_no", description: "The inpatient or out patient number assigned to th" }
]

consultation_form_fields.each do |field_data|
  FormField.create!(
    page: consultation_form,
    title: field_data[:title],
    description: field_data[:description]
  )
end

# Create form fields for the Log Update page (Care template)
log_update_fields = [
  { title: "physical_examination_info", description: "Physical Examination Details, including any complaints" },
  { title: "other_details", description: "Other details, including Treatement Plans, Advice," },
  { title: "diastolic", description: "Blood Pressure Diastolic as integer" },
  { title: "systolic", description: "Blood Pressure Systolic as integer" },
  { title: "temperature", description: "Temperature in Fahrenheit" },
  { title: "resp", description: "Respiratory Rate as integer" },
  { title: "spo2", description: "SPO2 Value as integer" },
  { title: "pulse", description: "Pulse Rate as integer" }
]

log_update_fields.each do |field_data|
  FormField.create!(
    page: log_update,
    title: field_data[:title],
    description: field_data[:description]
  )
end

# Create form fields for the Demo Page 1 (Medispeak template)
medispeak_demo_fields = [
  { title: "gender", description: "Gender from options Male, Female, Other" },
  { title: "symptoms", description: "Applicable Symptoms from options Headache, Fever," },
  { title: "preferred_time", description: "The Preferred Time from the options Morning, After" },
  { title: "full_name", description: "Full name" },
  { title: "age", description: "Age of the user" },
  { title: "email", description: "Email of the user" },
  { title: "phone_number", description: "Phone Number of the user" },
  { title: "additional_notes", description: "Full text of the conversation" },
  { title: "date_of_birth", description: "Date of Birth as a Javascript Date String" }
]

medispeak_demo_fields.each do |field_data|
  FormField.create!(
    page: medispeak_demo_page,
    title: field_data[:title],
    description: field_data[:description]
  )
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
