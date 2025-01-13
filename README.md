# DevOps_Assignment
## 개요
1. [VPC 모듈](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)을 사용하여 Public, Private Subnet 및 Natgateway 구성
2. [EKS 모듈](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)을 사용하여 EKS 구축
3. [Spring Boot 이미지](https://spring.io/guides/gs/spring-boot-docker)로 제작된 Sample Application 배포 (단, affinity 옵션을 사용하여 Private Subnet에 배포되게 할 것)
4. ALB를 사용해 해당 Application로 라우팅

## Directory Structure
```
.
├── aws
│   ├── alb.tf
│   ├── ecr.tf
│   ├── eks.tf
│   ├── iam.tf
│   ├── main.tf
│   ├── network.tf
│   ├── securitygroup.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
├── k8s
│   ├── aws-loadbalancer-controller
│   └── cert-manager
└── services
    └── helloworld
        ├── Dockerfile
        ├── k8s.yaml
        └── src
```
* `aws` : aws 구성을 위한 테라폼 프로젝트
* `k8s` : kubernetes에 배포되어야 하는 manifest 관리
* `services` : 서비스 관리
  * `Dockerfile` : 해당 서비스의 Dockerfile 정의
  * `k8s.yaml` : 해당 서비스의 kubernetes manifest 정의
  * `src` : 해당 서비스의 소스 관리
 
## 설명
### Infra
* `aws/network.tf` 에서 기본적인 네트워크 구성을 진행하였습니다.
  * 이 때, AWS Loadbalancer Controller 사용을 위해 Public Subnet에 적절한 태그를 붙여주었습니다.
* `aws/eks.tf` 에서 eks 클러스터를 생성하였습니다.
  * 클러스터 운영에 필요한 addon(coredns, kub-proxy, vpc-cni)를 함께 설치하도록 하였습니다.
  * 테스트 프로젝트라서 VPN 구성 등의 작업을 진행하지 않았기에 `cluster_endpoint_public_access`를 true로 하여 테스트 하였습니다.
  * `eks_managed_node_groups` 서브모듈을 사용하게하여 aws autoscaling group을 사용하여 노드를 관리해주었습니다.
    * 비록 private subnet에만 노드구성을 하였으나 `subnet_ids` variables를 지정하여 명확하게 worker 노드 그룹은 private subnet에 배포되게 합니다.
    * 효율적인 노드관리를 위해 SSM 권한을 허용해주었습니다.
* `aws/securitygroup.tf` 에서 필요한 sg들을 생성해주었습니다. (nodegroup, alb)
* `aws/iam.tf` 에서 aws-loadbalancer-controller 사용을 위한 IRSA IAM Role을 선언해주었습니다.
* `aws/ecr.tf` 에서 application 이미지를 보관할 ecr을 생성해주었습니다.
* `aws/alb.tf` 에서 alb를 생성하였습니다.
  * 별도의 인증서를 attach하지는 않을 것이기에 80포트를 리슨하게 하였고, targetgroup을 함께 생성해두었습니다.

### 빌드/배포
* application은 별도 커스텀 없이 `/`를 호출하면 `Hello Jaehwan World`를 return 하게 해주었습니다. (`services/helloworld/src/main/java/jaehwan/helloworld`)
* `services/helloworld/Dockerfile`을 사용해 Docker build 하였습니다.
* 빌드된 이미지를 ecr에 push 합니다.
* `services/helloworld/k8s.yaml`에 해당 application을 배포하기 위한 manifest를 명세하였습니다.
  * node label 기반으로 affinity 설정을 진행하였습니다. `zone: private`으로 라벨링 되어있는 노드의 a, c az에 배포되도록 설정하였습니다.
  * 1개의 application만 배포될 것이기 때문에 service를 NodePort 형식으로 생성하였습니다.
  * TargetGroupBinding(aws loadbalancer controller)을 사용하여 생성해둔 TargetGroup에 매칭하였습니다.

> [!NOTE]
> 만약 여러개의 application을 배포할 것을 전제로 하였다면
> [nginx ingress controller](https://docs.nginx.com/nginx-ingress-controller/) 혹은 istio, linkerd와 같은 서비스 매시를 해당 NodePort+TargetGroupBinding 방식으로 배포한 후
> ingress와 clusterIP 형식의 service를 생성하여 path 단위로 라우팅 진행

### 결과
* 별도의 도메인을 연결하지 않았기 때문에 ALB의 DNS를 직접 호출해봅니다.
![image](https://github.com/user-attachments/assets/8ca3bf82-f956-48a5-bb59-87c5fd44d321)

