<img src="../assets/k8sland.png" align="right" width="128" height="auto"/>

<br/>

# <img src="../assets/lab.png" width="32" height="auto"/> Deployment Lab

> The Hangman Game Reloaded!

> The hangman game is composed of two separate services namely: **Dictionary** and **Hangman**.
> **Dictionay** provides a list of words loaded from a dictionary asset directory.
> **Hangman** calls up to the dictionary to get a list of words and picks a random word.
> It provides apis for creating a new game and validating your letter guesses.

1. Configure probes and resources for your dictionary service.
   1. You'll need to configure both a readiness and liveliness probes using `/api/v1/healthz`
2. Setup an HPA on your dictionary pod. Set the target to 30% cpu and max 5 replicas
3. Provision your *Dictionary* deployment, service and HPA
4. Verify your deployment, service and hpa are happy!
5. Verify you can get a list of words from the dictionary service (/api/v1/words)
6. Configure probes and resources for your hangman service.
   1. You'll need to configure both a readiness and liveliness probes using `/api/v1/healthz`
7. Setup an HPA on your hangman pod. Set the target to 50% cpu and max 10 replicas
8. Provision your *Hangman* deployment and service
9. Verify your deployment and service are happy!
10. Verify you can create a new game from the Hangman service (/api/v1/new_game)
11. Load up your hangman application and verify the probes, resources and autoscaler are working nominally
12. Delete your entire application!


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

- Create the **hm** namespace

  ```shell
  kubectl apply -f k8s/ns.yml
  # Verify!
  kubectl get ns
  ```

- Provision your Dictionary

  ```shell
  kubectl apply -f k8s/dictionary.yml
  ```

- Verify Dictionary service is happy

  ```shell
  kubectl get -n hm svc,deploy,po,hpa
  ```

- Verify we can get some words!

  ```shell
  export D_POD=$(kubectl get pods -n hm -l app=dictionary -o jsonpath={.items[0].metadata.name})
  kubectl port-forward $D_POD 4001:4000 &
  http --print=b --pretty=colors :4001/api/v1/words
  # OR...
  curl -XGET http://localhost:4001/api/v1/words
  ```

- Create Hangman deployment and service

  ```shell
  kubectl apply -f k8s/hangman.yml
  ```

- Verify Hangman service is happy

  ```shell
  kubectl get -n hm svc,deploy,po,hpa
  ```

- Ensure Hangman can create a game!

  ```shell
  http --print=b --pretty=colors $(minikube ip):30500/api/v1/new_game
  # OR...
  curl -XGET http://$(minikube ip):30500/api/v1/new_game
  ```

- Create some load

  ```shell
  watch kubectl get -n hm hpa,po
  ab -n 100000 -c 2 http://$(minikube ip):30500/api/v1/new_game
  # Or...
  for i in {1..1000}; do wget -qO /dev/null http://$(minikube ip):30500/api/v1/new_game; done
  ```

- Delete the entire application

  ```shell
  kubectl delete -f k8s
  # OR... (NOTE!!)
  kubectl delete ns hm
  ```

<br/>

---
<img src="../assets/imhotep_logo.png" width="32" height="auto"/> © 2018 Imhotep Software LLC.
All materials licensed under [Apache v2.0](http://www.apache.org/licenses/LICENSE-2.0)
