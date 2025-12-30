#!/bin/bash
# User data script for EC2 instances
# Part 5: Variables and State

set -e

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Starting user data script ==="
echo "Environment: ${environment}"
echo "Instance ID: ${instance_id}"
echo "Hostname: $(hostname)"

# Update system packages
echo "=== Updating system packages ==="
dnf update -y

# Install basic tools
echo "=== Installing basic tools ==="
dnf install -y \
  httpd \
  git \
  curl \
  wget \
  vim

# Configure simple web server
echo "=== Configuring web server ==="
systemctl start httpd
systemctl enable httpd

# Create simple web page with instance info
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Tutorial - Part 5</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 { color: #2c3e50; }
        .info { margin: 10px 0; }
        .label { font-weight: bold; color: #34495e; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 Terraform Tutorial - Part 5</h1>
        <h2>Variables, Outputs & State</h2>
        <div class="info">
            <span class="label">Environment:</span> ${environment}
        </div>
        <div class="info">
            <span class="label">Instance Number:</span> ${instance_id}
        </div>
        <div class="info">
            <span class="label">Hostname:</span> <span id="hostname"></span>
        </div>
        <div class="info">
            <span class="label">Instance ID:</span> <span id="instance-id"></span>
        </div>
        <div class="info">
            <span class="label">Availability Zone:</span> <span id="az"></span>
        </div>
    </div>

    <script>
        // Fetch instance metadata
        fetch('http://169.254.169.254/latest/meta-data/hostname')
            .then(r => r.text())
            .then(data => document.getElementById('hostname').textContent = data);

        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(r => r.text())
            .then(data => document.getElementById('instance-id').textContent = data);

        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(r => r.text())
            .then(data => document.getElementById('az').textContent = data);
    </script>
</body>
</html>
EOF

echo "=== User data script completed successfully ==="
