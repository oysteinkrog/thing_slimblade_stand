include <thing_libutils/system.scad>
include <thing_libutils/units.scad>
include <thing_libutils/transforms.scad>
use <thing_libutils/shapes.scad>

test = false;
$preview_mode = false;
round_r = test ? 0*mm : 1*mm;

// high quality etc
is_build = true;

// minimum size of a fragment
// resolution of any round object (segment length)
// Because of this variable very small circles have a smaller number of fragments than specified usi#  6 // The default value is 2.
$fs = is_build ? 0.5 : 1;

// minimum angle for a fragment.
// The default value is 12 (i.e. 30 fragments for a full circle)
$fa = is_build ? 4 : 16;


feet_dist_front_x = 63.0*mm;
feet_dist_back_x = 81.0*mm;
feet_dist_y = 118*mm;

// degrees
tilt_ = [-10,0,0];
tilt = test ? [0,0,0] : tilt_;

feet_size=[15.3*mm,6.2*mm,1*mm];
padding = [10*mm, 10*mm, 2*mm];;
width = feet_size.x + padding.x + max(feet_dist_front_x, feet_dist_back_x);
depth = feet_size.y + padding.y + feet_dist_y;
height = min(sin(tilt.y)*width, sin(tilt.x) * depth);
size = [width, depth, round_r+.2*mm];
size_base = [width,cos(tilt.x)*depth,size.z];

stand();

module stand(part)
{
    if(part==U)
    {
        difference()
        {
            stand(part="pos");
            stand(part="neg");
        }
        %stand(part="vit");
    }
    if(part=="pos")
    {
        hull()
        {
            tz(sign(height)<0?-height:0)
            r(tilt)
            {
                rcubea(size=size, round_r=round_r, align=Y+Z);
            }

            rcubea(size=size_base, round_r=round_r, align=Y+Z);
        }
    }
    else if(part=="neg")
    {
        tz(sign(height)<0?-height:0)
        r(tilt)
        ty(size.y/2)
        {
            ty(feet_dist_y/2)
            for(x=[-1,1]*feet_dist_front_x/2)
            tx(x)
            rz(sign(x)*1.3)
            tz(size.z)
            tz(-.2*mm)
            cubea(size=feet_size, align=Z);

            ty(-feet_dist_y/2)
            for(x=[-1,1]*feet_dist_back_x/2)
            tx(x)
            rz(sign(x)*1.3)
            tz(size.z)
            tz(-.2*mm)
            cubea(size=feet_size, align=Z);
        }

        ty(20)
        cubea(size=[width-15,cos(tilt.x)*depth-40,1000*mm], align=Y);

        hull()
        {
            ty(depth)
            ty(-10)
            cubea(size=[feet_dist_front_x-30,20,1000*mm], align=-Y);

            ty(10)
            cubea(size=[feet_dist_back_x-30,20,1000*mm], align=Y);
        }

        // for some silicone feet
        ty(size_base.y/2)
        for(x=[-1,1])
        for(y=[-1,1])
        tx(x*(size_base.x/2-padding.x/2-5*mm))
        ty(y*(size_base.y/2-padding.y/2-5*mm))
        cylindera(h=1*mm, d=10.3*mm, align=-Z);
    }
    else if(part=="vit")
    {
        /*tz(sign(height)<0?-height:0)*/
        /*r(tilt)*/
        /*{*/
            /*ty(size.y/2)*/
            /*color("red")*/
            /*rcubea(align=Z);*/
        /*}*/
    }
}
