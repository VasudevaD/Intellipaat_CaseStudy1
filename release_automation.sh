#!/bin/bash

# ZSoftwares Monthly Release Script (Bash-only)

# Initialize 'develop' branch
git checkout -b develop

# Create initial app.txt (using a text file instead of .py for Bash-only approach)
cat <<EOF > app.txt
# Initial version of the ZSoftwares app.
Welcome to ZSoftwares App!
EOF

git add .
git commit -m "Initial commit on develop - created app.txt"

# Function to perform a monthly release
monthly_release() {
  month="$1"
  release_branch="release-$month"
  tag_name="v1.0.0-$month"  # Or use $(date +%Y.%m.%d) for date-based versioning

  git checkout -b "$release_branch" develop

  # Update app.txt (using sed for Bash-only approach)
  current_message=$(grep "ZSoftwares App -" app.txt)
  new_message="ZSoftwares App - $(date -d "2023-$month-01" +%B) Release!"
  if [[ -n "$current_message" ]]; then
    sed -i "s/$current_message/$new_message/g" app.txt
  else
    echo "$new_message" >> app.txt
  fi

  git add .
  git commit -m "Preparing $month release - updated welcome message"

  git checkout main
  git merge "$release_branch"
  git tag "$tag_name"

  git checkout develop
  git merge main

  git push origin main
  git push origin develop
  git push origin --tags

  git branch -d "$release_branch"
}

# Loop through the months (e.g., July to December)
for month in {07..12}; do  # Adjust the range as needed
  monthly_release "$month"
done

echo "Release process complete."