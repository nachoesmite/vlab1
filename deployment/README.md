<img src="../assets/k8sland.png" align="right" width="128" height="auto"/>

<br/>

# <img src="../assets/lab.png" width="32" height="auto"/> Deployment Lab

> Provision Hangman services and play the game!

The hangman game is composed of two separate services namely: Dictionary and Hangman.

+ **Dictionay** provides a list of words loaded from a dictionary asset directory.
+ **Hangman** calls up to the dictionary to get a list of words and picks a random word.
  It provides apis for creating a new game and validating your letter guesses.

## The HM namespace

1. Create a namespace for the services called 'hm' for hangman.

## Dictionary Service

1. Create a deployment and service
   1. Use the following image and tag: *k8sland/go-dictionary-svc:0.0.1
   2. Configure the dictionary pod command as follows:
      1. Command: /app/dictionary
      2. Arguments
         1. "-a assets" specifies the dictionaries asset directory.
         2. "-d words.txt" specifies a dictionary to use.
   3. Make sure your dictionary container exposes port *4000*
   4. Configure the dictionary services as follows:
      1. Service type: *ClusterIP*
      2. Service is exposed on port: *4000*
1. Provision your **Dictionary" deployment and service
1. Verify your deployment and service are happy!
1. Verify you can get a list of words from the dictionary service (/api/v1/words)

## Hangman Service

1. Create a deployment and service
   1. Use the following image and tag: *k8sland/go-hangman-svc:0.0.1
   1. Configure the hangman pod command as follows:
      1. Command: /app/hangman
      1. Arguments
         1. "-d <dictionary dns name>:<port>" specifies the dictionaries dns name and port
   1. Make sure your hangman container exposes port *5000*
   1. Configure the hangman service as follows:
      1. Service type: *NodePort*
      1. Service is exposed on nodePort: *30500*
1. Provision your **Hangman" deployment and service
1. Verify your deployment and service are happy!
1. Verify you can create a new game from the Hangman service (/api/v1/new_game)

## Play The Game

Fire off the Hangmam cli enjoy the fruits of your labor!!

```shell
kubectl run -i --tty --rm hangmancli -n hm --generator=run-pod/v1 \
--image k8sland/go-hangman-cli:0.0.1 \
--command -- /app/hangman_cli --hm hangman:5000
```

## Cleanup!

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

- Create the **hm** namespace

  ```shell
  kubectl apply -f k8s/ns.yml
  # Verify!
  kubectl get ns
  ```

- Create the Dictionary deployment and service

  ```shell
  kubectl apply -f k8s/dictionary.yml
  ```

- Verify the Dictionary service is happy

  ```shell
  kubectl get -n hm deploy
  kubectl get -n hm pod
  # Or...
  watch kubectl get -n hm deploy,po,svc
  ```

- Ensure the Dictionary Service is happy!

  ```shell
  export D_POD=$(kubectl get pods -n hm -l app=dictionary -o jsonpath={.items[0].metadata.name})
  kubectl port-forward $D_POD 4001:4000 &
  http --print=b --pretty=colors :4001/api/v1/words
  # OR...
  curl -XGET http://localhost:4001/api/v1/words
  ```

- Create the Hangman deployment and service

  ```shell
  kubectl apply -f k8s/hangman.yml
  ```

- Verify the Hangman service is happy

  ```shell
  kubectl get -n hm deploy
  kubectl get -n hm pod
  # Or...
  watch kubectl get -n hm deploy,po,svc
  ```

- Ensure the Hangman Service is happy!

  ```shell
  http --print=b --pretty=colors $(minikube ip):30500/api/v1/new_game
  # OR...
  curl -XGET http://$(minikube ip):30500/api/v1/new_game
  ```

- Delete Hangman

  ```shell
  kubectl delete -f k8s
  # OR... (NOTE!!)
  kubectl delete ns hm
  ```

<br/>

---
<img src="../assets/imhotep_logo.png" width="32" height="auto"/> © 2018 Imhotep Software LLC.
All materials licensed under [Apache v2.0](http://www.apache.org/licenses/LICENSE-2.0)
