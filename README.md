# Distributed face recognition
## _Using kubernetes cluster_

![Cuda](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/cuda_logo.png?raw=true)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![Dlib](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/dlib_logo.png?raw=true)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![k8s](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/kubernetes_logo.png?raw=true)


## Table of contents
1. [ Quick Start ](#quick)
2. [Features](#fea)
3. [ Describe ](#desc)
4. [ Used technology](#tech)
5. [ Helping ansible tags ](#gags)
6. [ CUDA Support ](#supp)
7. [ Without CUDA ](#without)
8. [ Example Result ](#res)
9. [ Prepare your own face database ](#prep)
10. [ Debug/Known Bugs](#bugs)
11. [ License ](#lic)

<a name="quick">.</a>
## Quick Start

To deploy:
```sh
git clone https://github.com/GHRik/Distributed-k8s-face-recognition.git
cd Distributed-k8s-face-recognition/ansible
ansible-playbook -i inventory.yaml main.yaml
```

<a name="fea">.</a>
## Features
Full automatization deploy:

- install [kubernetes](https://kubernetes.io/) and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) pkg
-  Create cluster with [calcio CNI](https://www.projectcalico.org/) and [nvidia GPU scheduling](https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/#deploying-nvidia-gpu-device-plugin)
- Deploy  [kubernetes](https://kubernetes.io/) resource (check [describe section](https://github.com/GHRik/Distributed-k8s-face-recognition/tree/master#desc)
- Support CUDA 9.2, 10.0, 10.1, 10.2 11.0, 11.0.3, 11.1, 11.1.1, 11.3
- Recognize face as distrubuted way

<a name="desc">.</a>
## Describe

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This repo is reworked code from [this repo](https://github.com/Skarlso/kube-cluster-sample) so if you want any info about components or how everything works together , check [this link](https://cheppers.com/deploying-distributed-face-recognition-application-kubernetes)

If you still dont know how it works, maybe this diagram will help you ;)
![Example](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/processSchema.jpg?raw=true)

### Where is distrubuted?

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[dlib](http://dlib.net/) have a Pool thread using to find face
![dis](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/distributed.PNG?raw=true)

<a name="tech">.</a>
## Used technology:
1. [dlib](http://dlib.net/) - module to recognize face
2. [cuda](https://developer.nvidia.com/cuda-zone) - to accelerate GPU card
3. [ansible](https://www.ansible.com/) - to automatization create cluster
4. [kubernetes](https://kubernetes.io/) - to create cluster
5. [my docker hub repo](https://hub.docker.com/repository/registry-1.docker.io/ghrik/face_recognition/tags?page=1&ordering=last_updated) - to store built images
6. [kubernetes-sample-cluster](https://github.com/Skarlso/kube-cluster-sample) - to pattern code
7. [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) - to passthrought my gpu to containers
8. [Microsoft azure cloud](https://azure.microsoft.com/) - for testing
9. [Calico](https://www.projectcalico.org/) - as CNI k8s plugin

<a name="gags">.</a>
## Helping ansible tags

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To deploy this code you can use ansible tags:

...

No install [nvida-docker](https://github.com/NVIDIA/nvidia-docker) and kubernetes packages
```sh
ansible-playbook -i inventory.yaml main.yaml
```
...

Have cluster, but dont have deploy cluster face fecogniton from this repo
```sh
ansible-playbook -i inventory.yaml main.yaml --tags "deploy"
```
...

Have cluster, have deployed face recognition from this repo,
but you make changes on kube files or known/unknown people images
```
ansible-playbook -i inventory.yaml main.yaml --tags "redeploy"
```
...

Have cluster, this face regoznition deployed, but images not load
or is an error in "recognize" role
```sh
ansible-playbook -i inventory.yaml main.yaml --tags "recognize"
```
...

Have cluster before , have deployed face recognition, but want to recreate cluster
```sh
ansible-playbook -i inventory.yaml main.yaml --tags "destroy_cluster" 
ansible-playbook -i inventory.yaml main.yaml
```
...

Have deployed face recognition cluster, but want clear it:
```sh
ansible-playbook -i inventory.yaml main.yaml --tags: "destroy"
```

<a name="supp">.</a>
## Cuda Support
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This code support CUDA. In this case if you want deploy this cluster with CUDA support:

Check your GPU - which version CUDA your GPU is using
```sh
nvidia-smi
```
You will see output like this:
```sh
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 465.19.01    Driver Version: 465.19.01    CUDA Version: 11.3     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA Tesla K80    Off  | 00000001:00:00.0 Off |                    0 |
| N/A   34C    P8    32W / 149W |      0MiB / 11441MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```
This cluster was tested uising CUDA 11.3 version, but on [my docker hub](https://hub.docker.com/repository/registry-1.docker.io/ghrik/face_recognition/tags?page=1&ordering=last_updated) you can pull other version. Only one pod will be running using CUDA support ***face_recognition***
If you want change a CUDA version, change this line on other version:
```sh
face_recognition.yaml

30: image: ghrik/face_recognition:cuda11.3
```
This script using [nvida-docker](https://github.com/NVIDIA/nvidia-docker) to deploy GPU Scheduling on k8s cluster. In this case **you should uninstall your docker if you have**.


<a name="without">.</a>
## Without CUDA Support
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You can run this cluster without CUDA.

In this case you have to change
```sh
face_recognition.yaml

30: image: ghrik/face_recognition:1.0
```

<a name="res">.</a>
## Result from example
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Results are in two pleaces:

***Result.txt*** - If ansible end properly this file will be fill with 
the calculated time it takes to recognize a given face

```sh
$ cat results/results.txt

Server is on: http://10.98.219.249:8081
LOGS:
Checking image: unknown_people/unknown_02.PNG
Time: 0.4799957275390625 sec.

Checking image: unknown_people/unknown_03.PNG
Time: 0.6136119365692139 sec.

Checking image: unknown_people/unknown_04.PNG
Time: 0.5596208572387695 sec.

Checking image: unknown_people/unknown_01.PNG
Time: 0.46269893646240234 sec.

```

The first line from ***result.txt*** is a ip to frontend site.
On this site you will see what faces have been recognized.
![Example](https://github.com/GHRik/Disturbed-k8s-face-recognition/blob/master/need_jpg/example.PNG?raw=true)

<a name="prep">.</a>
## Prepare your own face database
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;As you can see this cluster is checking only faces in ***unknown_people*** dir.
To make your own database with face you change do a small change in
```sh
ansible/kube_files/database_setup.sql
```

So the first step is a create relation ***people-face***
```sh
insert into person (name) values('Damian');
insert into person (name) values('Barack');
insert into person (name) values('Duda');
insert into person (name) values('Lewy');
```
It is very simple, add only something like that


The next step is create relation 
***picture from known_people - people_id***
```sh
insert into person_images (image_name, person_id) values ('damian_01.PNG', 1);
insert into person_images (image_name, person_id) values ('damian_02.PNG', 1);
insert into person_images (image_name, person_id) values ('barack_01.jpg', 2);
insert into person_images (image_name, person_id) values ('barack_02.PNG', 2);
insert into person_images (image_name, person_id) values ('duda_01.PNG', 3);
insert into person_images (image_name, person_id) values ('duda_02.PNG', 3);
insert into person_images (image_name, person_id) values ('lewy_01.PNG', 4);
insert into person_images (image_name, person_id) values ('lewy_02.PNG', 4);
```

<a name="bugs">.</a>
## Debug / Known Bugs
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In any case of error check for the first ***image_processor*** pod
```sh
kubectl logs image_processor
```
- List_out_of range <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Probably one of images (from ***unknown/known_people)*** does not have any face
to recognize. In this case image_processor cant process this image.

- ***Image_processor*** is not up <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sometimes a ***image_processor*** must have a more time to get up.
You can see it if you run new cluster. Pulling image to pod can take a long time

- No such file or directory on image processor pod <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sometimes ***face_recog_unknown_pvc*** is connected to ***face_recog_known_pv***,
rerun with "redeploy" tag

- ***dont_delete*** dir in unknown_people <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dont delete ***end.jpg*** , it is corelated with show time all recognized faces.

- Sleep 60 in recognize <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sometimes a other services need more time to get up.
To fast deploy you can comment "sleep 60", and after failed deploy recognize, 
rerun with tag: "recognize"

- Circuitbreaker is engaged <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;It means you have more than 5images in ***unknown_people*** dir. 
Probably it will unfreeze if not, you can add sleep function in
```sh
ansible/roles/recognize/tasks/main.yaml

40: shell: sleep 10 && curl -d '{"path":"{{ item.path }}"}' http://{{ receiver_ip.stdout }}:8000/image/post
```
Or add fewer face pictures ;)

- Core dump using without CUDA image <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***ghrik/face_recognition:1.0*** was builded with AVX acceleration.
All of CUDA images is using SSE4 (not AVX)
If you want to use dlib without AVX acceleration check flags in dlib section:
```sh
images/face_recognitionGPU/Dockerfile
```
and colerate this with
```sh
images/face_recognition/Dockerfile
```

<a name="lic">.</a>
## License
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Free to use ;)
