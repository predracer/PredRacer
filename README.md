# PredRacer: Predictively detecting data races inAndroid applications

The repository stores our implementations for the approach **PredRacer** proposed in paper "PredRacer: Predictively detecting data races inAndroid applications". 

## Abstract
Android platform offers a hybrid concurrency model encompassing multi-threading and asynchronous messaging for concurrent programming. The model is powerful but complex, making it difficult for developers to analyze concurrent behaviors. Data race, a prevalent concurrency defect in real-world Android applications, often results in abnormal executions of mobile applications, even crashes. Despite quite a few studies on detecting data races, it still suffers from high false positives with static analysis techniques and high false negatives with dynamic analysis techniques.
To address this issue, this paper presents a predictive approach, PredRacer, for detecting data races in Android applications. It first captures an execution trace of an Android application, and then  reorders the events within the trace based on partial orders. Finally, it checks the feasibility of the generated event sequence, which contains a potential data race. PredRacer increases the search scope and reduces false negatives while mitigating false positives by incorporating the happen-before relations specific to the Android concurrency model. The effectiveness of PredRacer is evaluated using the BenchERoid data set. Experimental results demonstrate that PredRacer achieves high precision, recall, and F1 score, outperforming the state-of-the-art techniques. A collection of 20 open-source Android applications is further utilized to assess the effectiveness of PredRacer, and an evaluation of 300 wild apps is conducted to assess its efficiency and scalability.


## Requirement

Java 8 as well as necessary packages are installed. 

## How to run
1. Create a root directory, and `git clone https://github.com/predracer/PredRacer.git` to the directory.
2. cd predracer
3. export ANDROID_JARS=path/Android/sdk/platforms/(export ANDROID_JARS=path/Android/sdk/platforms/)
4. PredRacer requires instrumentation of an Android APK, and we employ AspectJ for this purpose. The instrumentation files have been uploaded to the repository.
### Build PredRacer by running
1. For a single app: ./analyse_app.sh path/app_name.apk
2. For a data set: ./run_all.sh dataset_name

## Dataset
In the evaluation experiment, We first run PredRacer on the BenchERoid(https://github.com/seal-hub/bencheroid/tree/master). By utilizing BenchERoid as a dataset with known ground truth, we were able to report the precision, recall  and F1 score of PredRacer's detection results. we compiled a dataset of 20 real-world Android applications, consisting of 11 applications from the Curated dataset referenced in prior literature , and an additional 9 applications sourced through searches conducted on open-source code repositories such as GitHub and Gitee. Finally, to assess the scalability and time efficiency of PredRacer, we randomly collected 300 apps from both Google Play Stor and Wandoujia. 


