#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newRV_noinc
#include "ppport.h"
#include "cv.h"
#include "highgui.h"

MODULE = Image::ObjectDetect		PACKAGE = Image::ObjectDetect

PROTOTYPES: ENABLE

SV *
xs_detect(cascade_name, filename)
        char *cascade_name;
        char *filename;
    PREINIT:
        CvHaarClassifierCascade *cascade;
        IplImage *img, *gray, *small_img;
        int i;
        CvMemStorage *storage;
        CvSeq *objects;
        CvRect *rect;
        AV *retval;
        HV *hash;
    CODE:
        cascade = cvLoad(cascade_name, 0, 0, 0);
        if (!cascade)
            croak("Can't load the cascade file");
        img = cvLoadImage(filename, 1);
        if (!img)
            croak("Can't load the image file");

        gray = cvCreateImage(cvSize(img->width, img->height), 8, 1);
        cvCvtColor(img, gray, CV_BGR2GRAY);
        cvEqualizeHist(gray, gray);

        storage = cvCreateMemStorage(0);
        objects = cvHaarDetectObjects(gray, cascade, storage,
                1.1, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0, 0));

        retval = newAV();
        for (i = 0; i < (objects ? objects->total : 0); i++) {
            rect = (CvRect*) cvGetSeqElem(objects, i);
            hash = newHV();
            hv_store(hash, "x", 1, newSViv(rect->x), 0);
            hv_store(hash, "y", 1, newSViv(rect->y), 0);
            hv_store(hash, "width", 5, newSViv(rect->width), 0);
            hv_store(hash, "height", 6, newSViv(rect->height), 0);
            av_push(retval, newRV_noinc((SV *) hash));
        }

        cvReleaseMemStorage(&storage);
        cvReleaseImage(&img);
        cvReleaseImage(&gray);

        RETVAL = newRV_noinc((SV *) retval);
    OUTPUT:
        RETVAL

