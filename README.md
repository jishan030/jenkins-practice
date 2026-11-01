# Jenkins Practice

Jenkins CI/CD seekhne ki meri hands-on practice repo. Isme EC2 par Jenkins setup, GitHub webhook, master-slave (agent), Pipeline as Code aur Terraform pipelines ke working examples hain.

## Setup jisme practice ki

| Cheez | Detail |
|---|---|
| Jenkins | v2.580.2, AWS EC2 (Amazon Linux 2023) par |
| Master (controller) | Jenkins service, port `8080` |
| Agent (slave) | `agent-1`, label `linux-agent`, WebSocket se connected |
| Trigger | GitHub webhook (push par auto build) |
| IaC | Terraform (local provider demo, AWS ki zarurat nahi) |

## Architecture

```
Developer --push--> GitHub --webhook--> Jenkins Master
                                            |
                                   label: linux-agent
                                            |
                                            v
                                      agent-1 (build, test, deploy)
```

Master job schedule karta hai, agent actual kaam karta hai.

## Repo structure

```
jenkins-practice/
├── Jenkinsfile                 # hello-job ka pipeline (agent-1 par chalta hai)
├── hello.sh                    # demo script
├── .gitignore                  # Terraform state aur cache ignore
├── Day-3-jenkins-master-slave/
│   └── Jenkinsfile-run-matching-labels
├── Day-4-parameters-and-approval/
│   └── Jenkinsfile-when-and-script
└── Day-5-terraform-jenkins/
    ├── Jenkinsfile-ex6-apply-destroy-parameter
    └── terraform-demo/
        └── main.tf
```

## Kya-kya cover hua

| Folder / File | Concept |
|---|---|
| `Jenkinsfile` (root) | Pipeline as Code, stages, `post` block, agent label |
| `Day-3-jenkins-master-slave/Jenkinsfile-run-matching-labels` | `agent { label '...' }` se job ko specific agent par bhejna |
| `Day-4-parameters-and-approval/Jenkinsfile-when-and-script` | `parameters`, `when`, `input` (manual approval), `script` |
| `Day-5-terraform-jenkins/Jenkinsfile-ex6-apply-destroy-parameter` | Terraform init, plan, approval, apply ya destroy (parameter se) |
| `Day-5-terraform-jenkins/terraform-demo/main.tf` | Safe demo: sirf ek text file banata hai |

## Kisi bhi Jenkinsfile ko kaise chalayein

1. Jenkins me **New Item -> Pipeline** banao
2. **Definition:** `Pipeline script from SCM`
3. **SCM:** Git
4. **Repository URL:** `https://github.com/jishan030/jenkins-practice.git`
5. **Branch Specifier:** `*/main`
6. **Script Path:** jis file ko chalana hai uska poora path, jaise
   `Day-4-parameters-and-approval/Jenkinsfile-when-and-script`
7. **Save** -> **Build Now**

Parameter wale pipelines me pehla build bina dropdown ke chalta hai. Dusre build se **Build with Parameters** dikhta hai.

## Pehle se chahiye

- Jenkins running aur agent `agent-1` online (label `linux-agent`)
- Terraform wale pipelines ke liye agent wali machine par Terraform:

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
```

## Agent connect karne ka tareeka (short)

1. **Manage Jenkins -> Nodes -> New Node** (Permanent Agent, label `linux-agent`, launch method: connect to controller)
2. Node page se secret copy karo
3. Machine par agent chalao:

```bash
mkdir -p ~/Jenkins-agent && cd ~/Jenkins-agent
curl -sO http://localhost:8080/jnlpJars/agent.jar
nohup java -jar agent.jar -url http://localhost:8080/ \
  -secret <SECRET> -name "agent-1" -webSocket \
  -workDir "$HOME/Jenkins-agent" > agent.log 2>&1 &
```

Secret kabhi repo me commit mat karo.

## Master-slave ka proof

Build ke Console Output ki pehli lines dekho:

| Output | Matlab |
|---|---|
| `Running on agent-1 in /home/ec2-user/Jenkins-agent/workspace/...` | Job agent par chala |
| `Running on Jenkins in /var/lib/jenkins/workspace/...` | Job master par chala |

## Common errors aur fix

| Error | Fix |
|---|---|
| `Couldn't find any revision to build` | Branch name check karo (`*/main`) |
| `Jenkinsfile not found` | Script Path aur file ka naam check karo |
| `Waiting for next available executor` | Label match karne wala agent online nahi hai |
| Webhook me laal cross | Security Group me port `8080` open karo, Payload URL end me `/` ho |
| Terraform destroy me state nahi mili | Apply aur destroy ek hi node par chalao |

## Cleanup

- Terraform wale pipeline me practice ke baad `Destroy` chalao
- Agent band karne ke liye: `pkill -f agent.jar`
- Practice khatam hone par EC2 instance stop karo

## Seekha kya

- CI/CD ka flow: push -> webhook -> build -> test -> deploy
- Pipeline as Code (Jenkinsfile repo me)
- Master-slave architecture aur label based job routing
- Parameters, manual approval aur conditional stages
- Jenkins se Terraform chalana
