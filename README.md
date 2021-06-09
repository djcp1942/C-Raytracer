# Raytracing Engine

This is a program which can generate an image using a relatively realistic simulation of light rays and their interactions with various objects.

#### Features
- Shadows
- Reflection
- Refraction
- Global illumination
- Procedural textures

## Table of Contents
[Build](https://github.com/wojciech-graj/raytracing-engine/blob/master/README.md#Build)\
[Gallery](https://github.com/wojciech-graj/raytracing-engine/blob/master/README.md#Gallery)\
[History](https://github.com/wojciech-graj/raytracing-engine/blob/master/README.md#History)

## Build
To build the program on linux with gcc:
```
make release
```

## Gallery
Higher resolution images can be found in [images/](images/)
![SCENE4](/images/scene4_low.png)
The 5 platonic solids and a Utah teapot. All of them are reflective, so reflections of the environment and eachother can be seen.

![SCENE1](/images/scene1_low.png)
Three colored reflective spheres on a reflective surface.

![SCENE3](/images/scene3_low.png)
A sphere which is both reflective and transparent, with the refractive index of glass [1.48], next to an unreflective yellow sphere.

![SCENE2](/images/scene2_low.png)
A reflective torus surrounded by colored spheres. The reflections in the torus are somewhat distorted because the torus is made out of many triangles and does not have a smooth surface.

![SCENE5](/images/scene5_low.png)
Five transparent sphere with various refractive indices. The leftmost sphere has a refractive index of 1.0, and each next one has a 0.2 higher index, with the rightmost one having a refractive index of 1.8.

![SCENE6](/images/scene6_low.png)
Two spheres, with the left one being reflective, and the right one being transparent and having the refractive index of glass [1.48].

## History
###### 2020-12-26 \<6532a98e1e6bd11da1c537ae2454133ed9e06262>
The first image which was generated demonstrated intersections of rays and spheres. Rays are generated by creating an image plane in front of the camera, and dividing it into a grid of pixels. Then, a ray is cast from a fixed point behind the camera through the pixel and into the scene. Then, if it intersects an object, the color of that pixel is set to be the color of the object. The intersection points of a sphere with a line can be determined by solving a quadratic equation created by combining the equation for a sphere and line. By choosing the closest intersection, the closer red sphere can cover parts of the farther green sphere.\
![HISTORY1](/images/history/history_1.png)

###### 2020-12-26 \<b31fa194a31f59dd1c9cb05582b6a9999b55d66f>
More primitive shapes had to be added, and the two which were the most important were triangles and planes. Intersections with planes are very easy to calculate, however finding the intersection of a line and triangle is quite a bit harder. One of the most computationally efficient methods, which is the one I used, is the [Möller–Trumbore intersection algorithm](https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm).\
![HISTORY2](/images/history/history_2.png)

###### 2020-12-27 \<be449cdc695bba355860560c3f374e08803e3dde>
The next thing to do was add lighting which would give the shapes their 3 dimensional appearance. While the [Blinn-Phong](https://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_reflection_model) reflection model is more computationally efficient than the [Phong shading and reflection model](https://en.wikipedia.org/wiki/Phong_reflection_model), the Phong model is far simpler to implement so that is the model which was used. In this shading model, every object has 4 parameters: \
ks [specular reflection constant], \
kd [diffuse reflection constant], \
ka [ambient reflection constant],\
α [shininess constant].\
The specular reflection constant determines the brightness of the mirror-like reflections, such as those which can be seen as a white spot on the red sphere. The shininess constant works in tandem with the specular reflection constant, and determines the size of the specular reflection.\
Diffuse reflection is a phenomenon which is caused by a ray of light being scattered in many directions upon reaching a rough surface, and can be seen on the illuminated parts of the green sphere. While it would be very inefficient to calculate the scattering of each ray, a good approximation can be achieved by using the diffuse reflection constant.\
Finally, there is the ambient reflection constant, which determines how much of a scene's ambient light is reflected. In the real world, the bouncing of light rays would cause parts of objects which are not facing a light source to be illuminated, however such calculations are extremely expensive, and instead, it is much simpler to assume that some amount of light (the ambient illumination) will be present on every object.\
![HISTORY3](/images/history/history_3.png)

###### 2020-12-28 \<05a0b33e5448aecb0f2f1943d6d9a45ba68d29a6>
Now that all of the primitive shapes had been programmed, it was time to find a use for them. The most common representation of complex shapes which is used by computers is a triangle mesh. While the [stl file format](https://en.wikipedia.org/wiki/STL_%28file_format%29) is mostly used for 3D printing, it is exactly what's needed. Every stl file contains a fixed-length header, followed by a number which represents the number of triangles which the mesh contains, and then the vertices of each triangle. Upon parsing this file, an object containing all of these triangles could be created and displayed, and the code for finding the intersection of a line and triangle could be reused. The mesh which was used in the image, and will be used in subsequent images, is the [Utah Teapot](https://en.wikipedia.org/wiki/Utah_teapot).\
Between the creation of this image and the next one, some optimization had to be done. Even this simple mesh contains approximately 900 triangles, and it is not efficient to calculate the intersection of each ray with each of the triangles if the ray does not even pass remotely close to the mesh. In order to solve this problem, a bounding sphere had to be created. This would be a sphere that would encompass the entire mesh, and all ray collisions would be checked with the sphere. Only if an intersection was found, would all of the triangles be tested. Creating the smallest possible sphere that encompasses a set of 3d points is very difficult and computationally expensive, so [Ritter's algorithm](https://en.wikipedia.org/wiki/Bounding_sphere#Ritter's_bounding_sphere) is used. While it typically produces spheres which are 5%-20% larger than the optimal sphere, it is also very simple.\
![HISTORY4](/images/history/history_4.png)

###### 2020-12-28 \<7b1b03623a53216a400ed222b20322b8f78f8846>
The next feature on the chopping block was adding shadows. This was perhaps one of the easiest features to implement, because every time a ray lands on an object, the point at which it intersected can be found. Then, a second ray can be created from the point to a light source. The point will be illuminated by the light if this second ray does not intersect any objects along the way. However, a there is a problem with this. While this light model is very accurate in a situation with only a single point-source of light, in the real world, light is emitted by an area. By only using a single point of light, shadows have hard edges, unlike those which would be found if a light-emitting area were to be used. This issue was be addressed later.\
![HISTORY5](/images/history/history_5.png)

###### 2020-12-28 \<c6946be94c74066699da6b3824c3d8425b9fc42f>
One of the main reasons for using raytracing to render images is the ability to have light reflect multiple times. In order to create reflections, another constant was added to objects:\
kr [specular interreflection constant].\
Specular interreflection is different to the aforementioned specular reflection because specular reflection only encompasses the reflection of light from a light source, whereas specular interreflection is the reflection of the ray projected from the eye onto other parts of the scene. In order to calculate the vector of the reflection ray, the incident ray needs to be reflected across the surface normal. Then, this reflection ray can have the same process of calculating intersections performed on it until it eventually reaches a surface which is not reflective.\
![HISTORY6](/images/history/history_6.png)

###### 2020-12-29 \<0ef89edf60b03c8001f39edf47113ba0db179f0e>
Much progress hadn't occurred between this image and the previous one in terms of the actual image, however a lot of work was done behind the scenes. The program was now able to accept command line arguments, allowing the user to specify parameters such as the field of view. The field of view did not affect the focal length, which was kept at a constant value of 1.0, but the size of the image through which the rays pass was adjusted. Also, json files which contained information about the scene were now being parsed with the help of the [jsmn library](https://github.com/zserge/jsmn). This allowed for the program to render any scene without having to be recompiled. Furthermore, the way in which intersections were calculated was changed. Initially, when finding the intersection of a ray with the sphere, the smallest distance value was selected. As long as the distance was > 0, i.e. it was in front of the origin of the ray, it was counted as an intersection. However, it is possible for the smallest distance to be negative, but for the farther distance, where the other intersection of the ray with the same sphere occurs, to be positive. This could happen if the ray was inside the sphere, and in the case of the triangle mesh, because a bounding sphere was created around it, this could occur. After fixing this oversight, the reflections became more realistic, as can be seen on the handle or the lid of the teapot.\
![HISTORY7](/images/history/history_7.png)

###### 2020-12-30 \<17df1c055c59bebcf4641f5ece548b0a3d4c1595>
A final major feature which was waiting to be added was transparency and light refraction. In order to accommodate for transparency, objects received an additional parameter:\
kt [transparency constant].\
Every time a light ray hits an object, if the object is transparent, an additional ray will have to be cast. This ray will enter the object, and the angle at which such a ray will point is decided by the ratio of the reflective indices of the object and the material surrounding it. [Snell's law](https://en.wikipedia.org/wiki/Snell%27s_law) is used to calculate the change in angle which the ray will have to undergo, and then the ray is rotated by said amount in the direction of the surface normal. In the image, the sphere has a refractive index of 1.48, which is the refractive index of glass. As can be seen, the image of the sphere's surroundings is distorted by this difference in refractive index. It is also interesting how total internal refraction can arise due to this difference in refractive index, and lead to rays being refracted multiple times inside of the object before exiting.\
![HISTORY8](/images/history/history_8.png)

###### 2020-12-30 \<fdf92bc8dab4b94330e07b8307ebf27be4188d16>
While the program was mostly done, there still remained some issues that needed addressing. One of the most glaring problems in the previous image is that, while the sphere is completely transparent, it still casts a shadow. The method used to calculate if a light source was obtruded was adjusted to take into consideration the transparency constant of intersected objects. The effect of this can be seen by the sphere with a transparency constant of 0.9 only casting a very faint shadow.\
Another feature that was still missing were lights that are an area instead of a point. The amount of time which it takes to render a scene increases drastically as these area lights are added, because each of these area lights is just a grid of point lights, each one of which has to be taken into consideration when determining the illumination of a point in the scene. But the effects are worth it, because the shadows in this image have soft edges, as they would in real life.\
![HISTORY9](/images/history/history_9.png)

######  2021-05-13 \<0fff5641c415c37346a026f882bd7f1d1dec836c>
The program fulfilled its purpose, but it was incredibly slow for two main reasons. The foremost issue was that spheres were used as the bounding shapes which surrounded each object, and with which collision was checked first. Calculating whether or not a ray intersects a sphere is far slower than checking if it intersects an axis-aligned cuboid (AABB), in part due to spheres requiring a square root calculation. While replacing the spheres with cuboids noticeably reduced the execution time, meshes consisting of many triangles were still a major inefficiency. If the bounding box around a mesh was found to intersect the ray, intersections of the ray with each triangle would then have to be checked. Additionally, in a scene with many objects, having to check if each one intersects the ray, even if they were very far from each other, massively contributed to execution time. To fix this, a bounding volume hierarchy (BVH) had to be implemented. A BVH is a binary tree of consecutively smaller AABB which are contained within the parent node's AABB. It could be visualized as a box, containing two smaller, boxes, each of which contain another two smaller boxes, until the final boxes contain the actual objects in the scene. The BVH was constructed by assigning each AABB a [Morton code](https://en.wikipedia.org/wiki/Z-order_curve), allowing for them to be consecutively split into two groups of similar volume. When checking the intersection of the ray with the BVH nodes' AABBs, if the ray is found to not intersect a certain AABB, all of the nodes contained within can be culled. The BVH was able to speed up the intersection checking by multiple orders of magnitude.\
Now that the performance was acceptable, it was time to slow the program down a bit. Global illumination is a phenomenon by which light bounces from objects onto others in their vicinity, regardless of whether or not they are reflective. If a matte green wall was placed next to a matte white one, a green hue would appear on the white wall, despite both of them being matte. There are many ways of achieving global illumination, and the simplest one is to simply have a constant amount of ambient light which is added to every object's color. This is the approach which was used previously, but it failed to simulate the indirect lighting. The replacement was [path tracing](https://en.wikipedia.org/wiki/Path_tracing). This is a Monte Carlo method which works by, at every point where an object's color must be sampled, sending out many beams of light in random directions, and then averaging the colors returned by those beams. While the images tend to be very noisy with few samples, the noise is reduced as the number of samples per pixel is increased. The contribution of each indirect ray is also dependent on its angle to the surface normal: rays which are angled further away from the normal contribute less to the color. Given this fact, the rays can be generated following a cosine-weighted distribution, leading to a larger density being close to the center where their contributions will be more impactful.
![HISTORY10](/images/history/history_10.png)

######  2021-05-13 \<836e7290a3fb63219e7f7527f168578c6bf2f001>
Light attenuates following the inverse square law, meaning that its intensity is proportional to the inverse square of the distance. In the previous image, the blue wall's indirect light on the ball was just as intense as that of the red wall, because there was no light attenuation. An interesting effect occurs if the distance is smaller than one, however, with the light becoming excessively bright at tiny distances, as shown in the picture. This was quickly remedied by adding 1 to the distance, ensuring that it is always greater than 1, thereby preventing the light intensity from increasing.
![HISTORY11](/images/history/history_11.png)

######  2021-06-09 \<CURRENT COMMIT>
Another feature which had to be added were textures. Mapping 2d textures onto various 3D objects can be a very complicated process, so I opted to use procedural textures. These are textures which are generated based on some function which takes 3D coordinates as parameters. Some interesting functions can be found [here](http://www.upvector.com/?section=Tutorials&subsection=Intro%20to%20Procedural%20Textures) and [here](https://graphics.cg.uni-saarland.de/courses/cg1-2017/slides/CG08-Texturing.pdf). The sphere in the bottom right has a checkerboard texture, which was achieved by rounding the coordinates to the nearest integer, then checking whether or not the sum of those integers was divisible by two. The sphere to its left has a brick texture, and the three behind them all use a combination of a periodic function and noise.\
Generating noise can be achieved by simply assigning a random value to each pixel. However, in order to have noise which blends together by having neighboring values be similar, simplex noise can be used. By adding the noise function of a particular point to the point's X value, then putting this value into a periodic function, unique and natural-looking textures can be produced. The sphere on the right uses a sine function, the one on the left uses a sawtooth function, and the back one uses a square function.
![HISTORY12](/images/history/history_12.png)
