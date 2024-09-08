document.getElementById('deployBtn').addEventListener('click', async () => {
    const logDiv = document.getElementById('log');
    logDiv.innerHTML = "Deploying Azure AD Group...";
  
    // You need to replace this with your Terraform Cloud or Azure AD API.
    const terraformCloudApiToken = 'YOUR_TERRAFORM_CLOUD_API_TOKEN';
    const workspaceId = 'YOUR_WORKSPACE_ID';
    const url = `https://app.terraform.io/api/v2/runs`;
  
    const body = {
      "data": {
        "type": "runs",
        "attributes": {
          "message": "Creating Azure AD group via Terraform",
          "is-destroy": false
        },
        "relationships": {
          "workspace": {
            "data": {
              "type": "workspaces",
              "id": workspaceId
            }
          }
        }
      }
    };
  
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${terraformCloudApiToken}`,
          'Content-Type': 'application/vnd.api+json'
        },
        body: JSON.stringify(body)
      });
  
      if (response.ok) {
        const result = await response.json();
        logDiv.innerHTML = `Azure AD Group Deployment started. Run ID: ${result.data.id}`;
      } else {
        logDiv.innerHTML = `Error: ${response.statusText}`;
      }
    } catch (error) {
      logDiv.innerHTML = `Deployment failed: ${error}`;
    }
  });
  