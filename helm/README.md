<img src="../assets/k8sland.png" align="right" width="128" height="auto"/>

<br/>

# <img src="../assets/lab.png" width="32" height="auto"/> Helm Lab

> Deploy a Dictionary Service as a Chart

1. Install helm and deploy Tiller on your cluster
2. Create a new dictionary chart
3. Define a deployment and a service
4. Define a HTTP probes helper to define a liveness and readiness probe as a template function
   1. The helper must take in a readiness/liveness probe url and port and
      produce a full probe using the following attributes:
      1. initialDelaySeconds(5)
      2. periodSeconds(10)
      3. failureThreshold(3)
      4. successThreshold(1)
      5. timeoutSecond(1)
   1. If some attributes are not specified in the chart values they must
      be defaulted as specified above
5. Use your custom helper in your chart deployment file to leverage your new helper
6. Validate your chart and helper using a dry run install
7. Install your unpackaged chart and verify the deployment and probes are working
8. Package your dictionary chart
9. Create a private github repo and checkin your new chart tarball and index file
10. Expose your new github repo as a [github page](https://help.github.com/en/articles/configuring-a-publishing-source-for-github-pages)
11. Deploy your dictionary chart from your custom repo
12. Exchange a classmate github page url and provision it as a chart repo
13. Deploy your classmate chart into your cluster!

<br/>

---

## Installation

1. Install [Helm](https://github.com/helm/helm/blob/master/docs/install.md)

   ```shell
   brew install kubernetes-helm
   # Install configs + tiller on your cluster (insecure!)
   helm init --upgrade
   ```

<br/>

---

## Commands

- Create a dictionary chart

  ```shell
  helm create dictionary
  # Verify
  helm lint dictionary
  ```

- Debug a chart

  ```shell
  helm install --dry-run --debug -n hm dictionary -f cust.yml
  ```

- Provision a chart

  ```shell
  helm install -n hm dictionary -f cust.yml
  ```

- Package your chart

  ```shell
  helm package dictionary
  ```

- Create a chart index

  > NOTE: You will need to create a vlab_chart git repo and expose it to
  > public internet using github pages feature.

  ```shell
  # Create a new directory and generate your packaged dictionary chart
  mkdir vlab-charts
  helm package YOUR_DICTIONARY_CHART_PATH
  # Verify your dictionary-0.1.0.tgz exists!
  # Create an index using your git page URL and dictionary chart location
  helm repo index --url MY_GIT_PAGES_REPO_URL .
  # For example using k8sland page URL...
  helm repo index --url https://k8sland.github.io/vlab-charts .
  # Verify an index.yaml file was created and has the correct content!
  # Checkin your package chart and index files
  git add . && git commit -m 'Initial drop' && git push
  ```

- Add your custom dictionary chart repo

  ```shell
  helm repo add vlab-charts MY_GIT_PAGES_REPO_URL
  # For example...
  helm repo add vlab-charts https://k8sland.github.io/vlab-charts
  # Verify!
  helm repo list
  ```

- Pull your remote charts locally

  ```shell
  helm repo update
  ```

- Locate your remote chart

  ```shell
  helm search dictionary
  ```

  ```text
  NAME                    CHART VERSION   APP VERSION     DESCRIPTION
  local/dictionary        0.1.0           1.0             A Dictionary chart for Kubernetes
  vlab-charts/dictionary  0.1.0           1.0             A Dictionary chart for Kubernetes
  ```

- Deploy your packaged chart

  ```shell
  helm upgrade hm vlab-charts/dictionary -f cust.yml
  ```

- Delete a chart

    ```shell
    helm delete hm --purge
    ```

<br/>

---
<img src="../assets/imhotep_logo.png" width="32" height="auto"/> © 2018 Imhotep Software LLC.
All materials licensed under [Apache v2.0](http://www.apache.org/licenses/LICENSE-2.0)
