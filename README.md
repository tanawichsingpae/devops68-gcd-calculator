# DEVOPS68 – GCD Calculator API Deployment

เอกสารนี้อธิบายขั้นตอน **ติดตั้งและ deploy ระบบแบบครบถ้วน** โดยใช้ Terraform เพื่อสร้าง Infrastructure บน AWS และ deploy REST API ที่พัฒนาด้วย Node.js + Express

เมื่อทำตามขั้นตอนนี้ ผู้ใช้จะสามารถ

* Provision Infrastructure บน AWS ได้อัตโนมัติ
* Deploy Application จาก GitHub
* เข้าถึง API ที่รันอยู่บน EC2 ได้จริง

---

# 1. ความต้องการของระบบ (Prerequisites)

ก่อนเริ่มต้องติดตั้งเครื่องมือดังต่อไปนี้

## 1.1 ติดตั้ง Git

ดาวน์โหลด

https://git-scm.com/downloads

ตรวจสอบการติดตั้ง

```
git --version
```

---

## 1.2 ติดตั้ง Terraform

ดาวน์โหลด

https://developer.hashicorp.com/terraform/downloads

ตรวจสอบ

```
terraform -version
```

---

## 1.3 ติดตั้ง AWS CLI

ดาวน์โหลด

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

ตรวจสอบ

```
aws --version
```

---

# 2. การเชื่อมต่อกับ AWS

ก่อนใช้งาน Terraform จำเป็นต้องเชื่อมต่อกับ AWS ด้วย AWS CLI

## 2.1 สร้าง Access Key จาก AWS

1. เข้า AWS Console
2. ไปที่ **IAM (Identity and Access Management)**
3. เลือก **Users**
4. เลือก User ของตนเอง
5. ไปที่แท็บ **Security credentials**
6. กด **Create access key**

AWS จะให้ค่า

```
Access Key ID
Secret Access Key
```

ให้บันทึกค่าทั้งสองไว้สำหรับใช้ในขั้นตอนถัดไป

---

## 2.2 ตั้งค่า AWS CLI

รันคำสั่ง

```
aws configure
```

กรอกข้อมูล

```
AWS Access Key ID: <YOUR_ACCESS_KEY>
AWS Secret Access Key: <YOUR_SECRET_KEY>
Default region name: ap-southeast-7
Default output format: json
```

หลังจากตั้งค่าแล้ว Terraform จะสามารถเชื่อมต่อกับ AWS ได้

---

# 3. Clone Repository

ดาวน์โหลดโปรเจคจาก GitHub

```
git clone https://github.com/tanawichsingpae/devops68-gcd-calculator.git
```

เข้าโฟลเดอร์โปรเจค

```
cd devops68-gcd-calculator
```

---

# 4. เข้าโฟลเดอร์ Terraform

```
cd terraform
```

ภายในโฟลเดอร์นี้จะมีไฟล์

```
main.tf
variables.tf
outputs.tf
```

ซึ่งใช้สำหรับสร้าง Infrastructure บน AWS

---

# 5. Initialize Terraform

เตรียม environment และดาวน์โหลด provider

```
terraform init
```

---

# 6. ตรวจสอบแผนการสร้าง Infrastructure

```
terraform plan
```

Terraform จะแสดงรายการ resource ที่จะถูกสร้าง เช่น

* EC2 Instance
* Security Group
* SSH Key Pair

---

# 7. Provision Infrastructure และ Deploy Application

รันคำสั่ง

```
terraform apply
```

เมื่อ Terraform ถามยืนยัน

```
Do you want to perform these actions?
```

ให้พิมพ์

```
yes
```

Terraform จะดำเนินการดังนี้

1. สร้าง EC2 Instance บน AWS
2. สร้าง Security Group และเปิด port สำหรับ API
3. สร้าง SSH Key Pair สำหรับเข้าเครื่อง
4. ติดตั้ง Node.js บน EC2
5. Clone source code จาก GitHub
6. ติดตั้ง dependencies ของ Node.js
7. เริ่มต้น API Server

ขั้นตอนทั้งหมดนี้จะเกิดขึ้น **อัตโนมัติผ่าน Terraform**

---

# 8. การใช้ SSH Key Pair ที่ Terraform สร้าง

หลังจาก deploy สำเร็จ Terraform จะสร้างไฟล์ SSH key เช่น

```
gcd-terraform-key.pem
```

ไฟล์นี้ใช้สำหรับ SSH เข้า EC2

ตัวอย่างการเชื่อมต่อ

```
ssh -i gcd-terraform-key.pem ubuntu@<EC2_PUBLIC_IP>
```

---

# 9. รับ URL สำหรับใช้งาน API

หลัง deploy เสร็จ Terraform จะแสดง output เช่น

```
api_url = http://<EC2_PUBLIC_IP>:3017/calculate?a=48&b=18
```

---

# 10. ทดสอบการทำงานของ API

เปิด Browser หรือใช้ curl

```
http://<EC2_PUBLIC_IP>:3017/calculate?a=48&b=18
```

ตัวอย่าง Response

```
{
  "a": 48,
  "b": 18,
  "gcd": 6
}
```

---

# 11. การลบ Infrastructure

หากต้องการลบ resource ทั้งหมดที่ Terraform สร้างขึ้น

```
terraform destroy
```

จากนั้นพิมพ์

```
yes
```

Terraform จะลบ

* EC2 Instance
* Security Group
* SSH Key Pair

---