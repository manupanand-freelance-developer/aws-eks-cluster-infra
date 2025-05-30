
# Terraform AWS EKS with 3-Tier Private VPC Setup

This Terraform project provisions a **3-tier VPC architecture** with **private EKS cluster deployment**, supporting **multi-AZ**, **NAT gateway**, **Internet Gateway**, **EIP**, and necessary **IAM roles**, **IRSA**, and **RBAC mappings** for secure Kubernetes access.

---

## 🚧 Infrastructure Overview

### 🔹 VPC Architecture
- **CIDR Block**: `10.10.0.0/16`
- **Public Subnets** (for NAT Gateway / IGW)
- **Private Subnets** (App/EKS)
- **DB Subnets** (optional or future use)
- Spread across **3 Availability Zones**.

### 🔹 Networking Components
- **Internet Gateway** (attached to Public Subnet)
- **NAT Gateway** (1 per AZ for high availability)
- **Elastic IPs** (for NAT)
- **VPC Peering** (optional: to Default VPC for access)

---

## 🛠️ EKS Cluster Details

### 🔸 Connect to cluster
```
aws eks update-kubeconfig --name dev-eks-cluster


```


### 🔸 IAM & Permissions

* **EKS Cluster Role** and **Node IAM Role** created
* **RBAC via `aws-auth` ConfigMap**
* `system:masters` access given to selected IAM roles

---

## ✅ Add-ons (Optional, but recommended)

You can deploy these via Terraform or `kubectl` after cluster provisioning:

* **Amazon VPC CNI**
* **CoreDNS**
* **KubeProxy**
* **EBS CSI Driver**




## 🔌 Connectivity & Peering

To access private EKS cluster:

* You **can connect from another VPC** (like default) **if peering is enabled** and routing is properly configured
* You **don’t need a public EC2** if you access from peered VPC

---

## 🧨 Abort & Cleanup

To safely cancel a Terraform run:

* Use `Ctrl+C`
* Then run:

```bash
terraform destroy -var-file=env-dev/main.tfvars
```

---

## 🧾 Usage

```bash
terraform init -backend-config=env-dev/state.tfvars
terraform plan -var-file=env-dev/main.tfvars
terraform apply -var-file=env-dev/main.tfvars
```

To destroy:

```bash
terraform destroy -var-file=env-dev/main.tfvars
```

---



## 📌 Notes

* Ensure your runner/EC2 has an IAM role with admin permissions.
* Check subnet AZ distribution; EKS requires **subnets in at least 2 AZs**.
* EKS authentication and authorization are **two separate things**.
* Add-on delays are often caused by **networking issues** (e.g., missing NAT or IAM policy for IRSA).


Feel free to open issues or raise discussions for improvements or bugs.

