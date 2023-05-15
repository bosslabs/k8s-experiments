# k8s-experiments

A local kubernetes environment for testing and learning.

### Install Lens K8s IDE
[Here](https://k8slens.dev/)

### Deploy Local Kubernetes Cluster
See [Kind Install Instructions](./kind/INSTALL.md)

Once your cluster is running, it should appear in the Lens Cluster directory, if not
import it using the kubeconfig file.

### Install Tfswitch (Terraform Package manager)
[Here](https://tfswitch.warrensbox.com/Install/)

### Deploy ArgoCD using terraform
```bash
cd terraform
tfswitch
terraform init
terraform apply
```
