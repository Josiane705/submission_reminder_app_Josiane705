#!/bin/bash

mkdir -p submission_reminder_app
cd submission_reminder_app
mkdir -p submission_reminder_app/app
mkdir -p submission_reminder_app/modules
mkdir -p submission_reminder_app/assets
mkdir -p submission_reminder_app/config

cat <<EOL > submission_reminder_app/config/config.env
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

cat <<EOL > submission_reminder_app/assets/submissions.txt
student, assignment, submission status
here, Shell Navigation, submitted
Noel, Shell Navigation, not submitted
Jojo, Shell Navigation, submitted
Racheal, Shell Navigation, submitted
Esther, Shell Navigation, not submitted
Josian, Shell Navigation, not submitted
Sarah, Shell Navigation, submitted
EOL

cat <<EOL > submission_reminder_app/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}

EOL

cat <<EOL > submission_reminder_app/app/reminder.sh
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "\$submissions_file"
EOL

cat <<EOL > submission_reminder_app/startup.sh
#!/bin/bash

./app/reminder.sh
EOL

chmod +x submission_reminder_app/app/reminder.sh
chmod +x submission_reminder_app/modules/functions.sh
chmod +x submission_reminder_app/startup.sh

