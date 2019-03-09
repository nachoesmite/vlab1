<img src="../assets/k8sland.png" align="right" width="128" height="auto"/>

<br/>

# <img src="../assets/lab.png" width="32" height="auto"/> PersistentVolumeClaim Lab

> Provision a Postgresql Database using secrets, persistentVolumes and persistentVolumeClaims.

1. Define a secret for your postgres database using keys user and password.
   1. Configure your secret to be used by environment variables `POSTGRES_USER` and `POSTGRES_PASSWORD`
2. Provision your secret on your cluster
3. Define a 5Gb PV using a hostPath based volume
4. Define a PVC requiring RW access to a 2Gb DB partition
5. Define a Postgres deployment requiring the PVC defined above
   1. Docker image: postgres:9.6.2-alpine
   2. Data dir: /var/lib/postgresql/data
6. Deploy your Postgres deployment
7. Verify your volume and claim are correctly bound
8. Ensure the volume is mounted correctly on your Postgres pod
9.  Ensure you can access the database locally
    1. psql -U user -W -h $(minikube ip) -p port
10. Create a new database
11. Recreate deployment
12. Check if your new database is there??
13. Delete your deployment

<br/>

---
## Install [Postgresql](http://braumeister.org/formula/postgresql)


    1. HomeBrew Install

        ```shell
        brew install postgresql
        ```

    2. Or... Manual Install

       [Postgres Installation](https://www.postgresql.org/docs/9.3/static/tutorial-install.html)

    3. Verify!

        ```shell
        psql -V
        ```

<br/>

---
## Commands

- Provision storage

  ```shell
  minikube ssh
  sudo mkdir /tmp/postgres-lab
  ```

- Deploy postgres

  ```shell
  kubectl apply -f k8s/pg.yml
  ```

- Verify!

  ```shell
  kubectl get po,pv,pvc
  ```

-- Check volume

  ```shell
  export POD_ID=`kubectl get po -l app=pg -o go-template='{{(index .items 0).metadata.name}}'`
  kubectl exec -it $POD_ID -- du -sh /var/lib/postgresql/data
  ```

- Create database

  ```shell
  psql -U YOUR_USER -h $(minikube ip) -p 30543 -c 'create database pvc_lab'
  ```

- Recreate deployment and verify DB

  ```shell
  kubectl delete -f k8s/pg.yml
  kubectl apply -f k8s/pg.yml
  psql -U fred -h $(minikube ip) -p 30543 pvc_lab
  # Type \q to exit!
  ```

- Clean up!

  ```shell
  ku delete -f k8s/pg.yml
  ```

<br/>

---
<img src="../assets/imhotep_logo.png" width="32" height="auto"/> © 2018 Imhotep Software LLC.
All materials licensed under [Apache v2.0](http://www.apache.org/licenses/LICENSE-2.0)