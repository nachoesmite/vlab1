<img src="../assets/k8sland.png" align="right" width="128" height="auto"/>

<br/>

# <img src="../assets/lab.png" width="32" height="auto"/> Service Lab

> In this lab we're going to deploy a dictionary service to serve a list of dictionary words from
> a given asset directory.

1. Create a namespace for this service called 'dic'.
1. Setup a namespace quota to retrict the number of pods and services to 1 object.
1. Create a dictionary service
   1. The service externally accessible from your machine and must be available on port 30400!
   1. The service must use internal port 4001 on the cluster and connect to the dictionary container on port 4000.

1. Create a dictionary pod *trump* to surface trump words.
   1. Use the following image and tag: *k8sland/go-dictionary-svc:0.0.1*
   1. Configure the dictionary pod command as follows:
      1. Command: /app/dictionary
      1. Arguments
         1. `-a assets` specifies the dictionaries asset directory.
         1. `-d trump.txt` specifies a dictionary to use.
   1. Make sure your dictionary container exposes port *4000*
1. Provision your *trump* dictionary pod and service
1. Verify your pod and service are happy!
1. Verify you can get a list of words from the dictionary service from your local machine (/api/v1/words)
1. Define a second dictionary pod *trick_or_treat* pod manifest
   1. Copy your trump pod manifest and rename the file trick_or_treat.yml
   1. Change the dictionary CLI argument to `-d trick_or_treat.txt` to serve a different list of words
1. Deploy your second pod in the dic namespace. What's happening?
1. Update to namespace quota to allow 2 pods in the namespace.
1. Redeploy your second dictionary pod and verify you can serve dictionary requests to either pods.
1. Delete your entire application!


<br/>

---
## Happy Installs [OPTIONAL]

We recommand for the lab to install a couple useful utilities if you're on OSX

1. Install [HTTPIE](https://httpie.org)

   ```shell
   brew install httpie
   # Verify!
   http google.com
   ```

2. Install [WATCH](http://osxdaily.com/2010/08/22/install-watch-command-on-os-x)

    ```shell
    brew install watch
    # Verify!
    watch --help
    ```

<br/>

---
## Commands

- Create the **dic** namespace

  ```shell
  kubectl apply -f k8s/ns.yml
  # Verify!
  kubectl get ns
  ```

- Create *trump* dictionary pod and service

  ```shell
  kubectl apply -f k8s/trump.yml -f k8s/svc.yml
  ```

- Verify Dictionary service is happy

  ```shell
  kubectl get -n dic deploy
  kubectl get -n dic pod
  # Or...
  watch kubectl get -n dic po,svc
  ```

- Verify we can get some words!

  ```shell
  http --print=b --pretty=colors $(minikube ip):30400/api/v1/words
  # OR...
  curl -XGET http://$(minikube ip):30400/api/v1/words
  ```

- Create *trick_or_treat* pod

  ```shell
  kubectl apply -f k8s/trick_or_treat.yml
  ```

- Delete the entire application

  ```shell
  kubectl delete -f k8s
  # OR... (NOTE!!)
  kubectl delete ns dic
  ```

<br/>

---
<img src="../assets/imhotep_logo.png" width="32" height="auto"/> © 2018 Imhotep Software LLC.
All materials licensed under [Apache v2.0](http://www.apache.org/licenses/LICENSE-2.0)
