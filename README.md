# Non-Rigid-Structure-from-Motion-based-on-SOCP-Winter-school
This project is a learning material for 2021 Winter school on SLAM in deformable environments. 
The cited reference is: Paper: A. Chhatkuli, D. Pizarro, T. Collins and A. Bartoli. Inextensible Non-Rigid Structure-from-Motion by Second-Order Cone Programming[J]. IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 40, no. 10, pp. 2428-2441, 1 Oct. 2018, doi: 10.1109/TPAMI.2017.2762669.

The network parts of this code has been delated as a potential homework for the winter school. The pre-operations, including basic data loading, CVX toolbox installing, and nearest-neighbour graph (NNG) generation, and the later-evaluation/vision operations have been provided. The readers can complete the following steps:

## Configuration 
This code is build based on CVX toolbox. Please install CVX (version later than Version 2.2) before running this code. Unzip file: toolbox_fast_marching.zip. Run main.m and answer the question: "Have you installed CVX? Y/N [Y]:"

## adding the constaints part based on the following convex problem:
Because we use the perspective camera, the 3D features are written using the depth variable and 2D known pixels.The deformation model is based on surface inextensibility, which says that the Euclidean distance between any two points pki and pkj is upper bounded by the geodesic distance dij. The geodesic distance dij and the NNG N can be computed easily as the template shape is given. 

![图片](https://user-images.githubusercontent.com/32351126/122714435-a3d74700-d2aa-11eb-9d5c-da0f04c33c2a.png)

The Second-Order Cone Programming model using the inextensibility and NNG is shown：

![图片](https://user-images.githubusercontent.com/32351126/122714249-5b1f8e00-d2aa-11eb-965f-655a77ad01b3.png)

## testing more provided datasets
The code includes multiple datasets: Flag, Hulk, and T-shirt datasets. The readers is encourage to test the other datasets by revising the basic data loading part and have a basic understanding about the performance of this alorithm.

![图片](https://user-images.githubusercontent.com/32351126/122715141-c9b11b80-d2ab-11eb-8696-10306fe9d4db.png)

## dealing with the missing data
The case with some missing data is very common in the NRSfM problem and its later applications. The provided code is only suitable for the result with full dataset. If some of the feature correspondences are missing, the inextensibility constaints connected with them need to be delete. The readers is encourage to consider this sitation.

## testing a more robust derived model
The basic problem formulation gives very good reconstructions when the input correspondences have no outliers. However in the presence of a few outlier correspondences, they break down easily. This is because the method does not model noise or errors in the point correspondences. We achieve robustness by introducing slack variables in the inextensibility constraint that can ‘capture’ outliers. The new formulation is:

![图片](https://user-images.githubusercontent.com/32351126/122720330-adfd4380-d2b2-11eb-838e-02c8b833388f.png)

