from Reconstruction_numba import Reconstruction
# from Reconstruction_det   ector_change import Reconstruction
import numpy as np
import glob, sys, os
import logging
import time
import matplotlib.pyplot as plt

pi = np.pi
logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)
# data = np.fromfile('Shepp_Logal_3d_256.dat', dtype=np.float32).reshape([256, 256, 256])
params = {'SourceInit': [0, 1000.0, 0], 'DetectorInit': [0, -500.0, 0], 'StartAngle': 0,
          'EndAngle': 2 * pi, 'NumberOfDetectorPixels': [512, 384], 'DetectorPixelSize': [0.5, 0.5],
          'NumberOfViews': 90, 'ImagePixelSpacing': [0.5, 0.5, 0.5], 'NumberOfImage': [256, 256, 256],
          'PhantomCenter': [0, 0, 0], 'RotationOrigin': [0, 0, 0],'ReconCenter':[0,0,0], 'Method': 'Distance', 'FilterType': 'hann', 'cutoff': 1,
          'GPU': 1, 'DetectorShape': 'Flat','Pitch':0}
R = Reconstruction(params)
filename = 'Shepp_Logan_3d_256.dat'
# filename = 'Shepp_Logan_3d_256.dat'

R.LoadRecon(filename, params['NumberOfImage'])
ph = R.image
start_time = time.time()
R.forward()
log.info('Forward %f' % (time.time() - start_time))
print(R.proj.shape)
proj0 = R.proj
R.SaveProj('proj_SheppLogan256_90.dat')

start_time = time.time()
R.Filtering()
R.backward()
log.info('Backward: %f' % (time.time() - start_time))
R.SaveRecon('Recon_SheppLogan256_90_fdk.dat')
