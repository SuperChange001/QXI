from matplotlib import pyplot as plt


data=[515, 513, 516, 512, 515, 513, 515, 513, 515, 513, 514, 512, 515, 512, 514, 511, 515, 512, 514, 512, 514, 512, 514, 512, 514, 512, 513, 512, 513, 511, 512, 511, 512, 511, 513, 510, 513, 511, 513, 511, 514, 511,
513, 511, 514, 512, 513, 512, 513, 511, 513, 511, 513, 511, 513, 511, 513, 511, 512, 511, 512, 511, 513, 511, 511, 511, 512, 510, 512, 511, 511, 510, 511, 510, 512, 509, 511, 510, 511, 510, 511, 509,
511, 509, 511, 509, 510, 509, 512, 509, 512, 510, 512, 511, 512, 510, 512, 510, 514, 510, 515, 512, 515, 512, 515, 512, 515, 512, 515, 512, 514, 512, 514, 512, 515, 512, 517, 512, 516, 514, 515, 514,
515, 512, 515, 512, 515, 512, 516, 512, 515, 513, 512, 512, 503, 512, 499, 505, 498, 500, 498, 497, 494, 496, 492, 493, 491, 491, 491, 489, 493, 489, 495, 491, 498, 492, 499, 496, 499, 498, 499, 498,
498, 497, 499, 498, 499, 498, 499, 498, 498, 498, 495, 498, 494, 494, 492, 492, 492, 489, 498, 490, 497, 494, 495, 496, 494, 494, 489, 493, 489, 488, 489, 488, 490, 488, 489, 488, 491, 488, 492, 488,
491, 490, 491, 490, 490, 489, 489, 488, 487, 488, 487, 486, 490, 487, 487, 488, 488, 487, 487, 487, 487, 486, 488, 486, 494, 487, 491, 491, 493, 490, 487, 491, 488, 487, 488, 487, 488, 488, 489, 487,
487, 488, 491, 487, 488, 489, 489, 488, 487, 488, 492, 487, 489, 489, 489, 488, 490, 488, 491, 488, 491, 488, 487, 489, 490, 487, 491, 488, 489, 488, 488, 488, 491, 488, 491, 489, 494, 490, 489, 491,
491, 489, 491, 489, 491, 489, 492, 489, 491, 490, 491, 489, 493, 489, 492, 491, 491, 491, 494, 489, 491, 491, 491, 490, 492, 489, 496, 490, 498, 494, 494, 497, 492, 494, 492, 491, 494, 490, 493, 491,
495, 492, 494, 491, 489, 492, 491, 488, 493, 489, 489, 490, 489, 488, 490, 488, 489, 488, 491, 488, 491, 488, 488, 489, 489, 488, 495, 488, 491, 492, 489, 491, 489, 488, 491, 488, 491, 489, 491, 489,
492, 489, 490, 490, 488, 489, 487, 487, 489, 487, 491, 488, 493, 488, 488, 491, 487, 487, 489, 487, 488, 488, 488, 487, 491, 488, 489, 489, 490, 488, 488, 488, 490, 487, 490, 488, 488, 488, 483, 487,
481, 485, 475, 482, 470, 477, 468, 473, 467, 469, 467, 468, 474, 469, 475, 475, 479, 477, 479, 481, 482, 481, 481, 483, 487, 483, 488, 484, 491, 487, 493, 489, 492, 491, 494, 491, 496, 492, 499, 495,
500, 497, 502, 499, 503, 501, 503, 502, 505, 501, 506, 503, 506, 504, 508, 504, 508, 506, 510, 508, 510, 508, 510, 508, 511, 509, 512, 509, 512, 510, 513, 510, 512, 511, 512, 510, 512, 511, 512, 511,
510, 510, 510, 509, 509, 509, 508, 507, 510, 508, 510, 508, 512, 508, 511, 510, 510, 510, 512, 509, 511, 510, 512, 510, 512, 510, 512, 510, 512, 510, 512, 510, 514, 510, 515, 512, 515, 512, 516, 512,
515, 513, 514, 513, 513, 512, 512, 512, 512, 511, 515, 511, 514, 512, 514, 512, 514, 512, 514, 512, 514, 512, 513, 511, 513, 511, 514, 511, 512, 512, 511, 510, 512, 510, 512, 510, 514, 510, 514, 511,
512, 512, 517, 511, 513, 513, 512, 512, 511, 511, 511, 511, 510, 510, 510, 509, 509, 509, 510, 508, 510, 509, 509, 509, 509, 508, 510, 508, 509, 509, 508, 508, 510, 508, 508, 509, 508, 507, 509, 508,
508, 507, 504, 507, 508, 504, 510, 505, 507, 507, 507, 506, 509, 506, 508, 507, 507, 508, 508, 506, 506, 507, 508, 504, 508, 507, 507, 508, 507, 506, 509, 506, 508, 507, 508, 508, 508, 507, 506, 507,
506, 505, 501, 504, 505, 501, 507, 502, 505, 504, 505, 504, 504, 504, 503, 503, 504, 502, 505, 503, 505, 503, 506, 504, 503, 504, 504, 502, 500, 503, 501, 500, 500, 500, 500, 499, 501, 500, 502, 500,
501, 500, 500, 500, 501, 500, 499, 500, 499, 498, 499, 498, 499, 498, 499, 498, 500, 498, 499, 499, 499, 499, 498, 498, 498, 498, 502, 497, 498, 500, 491, 498, 490, 492, 487, 488, 486, 487, 487, 486,
487, 486, 486, 486, 487, 486, 491, 486, 496, 489, 495, 493, 494, 494, 493, 492, 491, 491, 489, 489, 489, 487, 492, 488, 487, 490, 489, 487, 487, 487, 488, 486, 489, 487, 487, 488, 487, 487, 485, 487,
484, 486, 482, 484, 483, 484, 485, 484, 487, 485, 486, 486, 483, 486, 483, 484, 483, 484, 485, 484, 484, 485, 483, 485, 483, 485, 480, 483, 480, 482, 480, 482, 483, 482, 481, 484, 482, 482, 480, 483,
482, 481, 483, 483, 479, 485, 483, 481, 480, 483, 479, 481, 478, 482, 480, 480, 481, 481, 478, 483, 478, 480, 477, 480, 479, 479, 480, 480, 479, 481, 478, 481, 476, 479, 477, 478, 477, 478, 476, 477,
476, 478, 478, 477, 478, 480, 479, 479, 477, 480, 481, 479, 479, 482, 477, 481, 476, 479, 478, 479, 479, 478, 476, 480, 477, 478, 478, 478, 478, 479, 477, 479, 477, 478, 479, 478, 478, 480, 477, 479,
478, 478, 478, 478, 478, 479, 478, 479, 477, 479, 478, 478, 478, 478, 477, 479, 480, 479, 480, 481, 480, 481, 477, 481, 476, 479, 476, 479, 477, 477, 476, 477, 476, 477, 476, 478, 476, 477, 477, 478,
477, 478, 483, 478, 479, 484, 478, 481, 480, 480, 480, 481, 480, 481, 480, 481, 481, 481, 480, 482, 478, 481, 482, 480, 481, 482, 488, 482, 486, 485, 485, 487, 484, 486, 483, 485, 483, 484, 483, 484,
482, 483, 482, 483, 480, 483, 483, 481, 486, 483, 488, 484, 486, 487, 483, 486, 481, 485, 480, 482, 480, 481, 476, 481, 476, 478, 474, 478, 475, 476, 476, 476, 479, 476, 480, 480, 484, 482, 482, 485,
481, 483, 486, 482, 483, 484, 484, 485, 484, 484, 486, 484, 487, 485, 488, 486, 490, 487, 492, 488, 494, 490, 495, 492, 495, 493, 497, 494, 498, 495, 497, 497, 498, 496, 499, 497, 500, 497, 498, 499,
498, 498, 503, 498, 501, 500, 500, 500, 499, 500, 501, 498, 501, 500, 502, 500, 501, 500, 503, 500, 502, 501, 502, 501, 502, 501, 505, 501, 506, 502, 506, 504, 507, 504, 508, 505, 509, 507, 508, 508,
509, 507, 508, 508, 508, 508, 508, 507, 508, 507, 509, 507, 508, 507, 508, 507, 508, 507, 509, 508, 509, 507, 508, 507, 509, 507, 509, 508, 508, 508, 509, 507, 509, 508, 510, 508, 509, 508, 509, 508,
508, 508, 508, 508, 507, 507, 507, 506, 509, 506, 510, 508, 509, 509, 508, 508, 510, 508, 517, 508, 514, 512, 512, 512, 511, 510, 512, 510, 510, 511, 510, 509, 511, 509, 509, 510, 511, 508, 511, 509,
511, 509, 512, 509, 512, 510, 510, 511, 510, 509, 508, 509, 510, 507, 512, 508, 512, 510, 511, 510, 511, 509, 511, 509, 510, 509, 511, 509, 511, 510, 512, 509, 512, 510, 512, 510, 512, 511, 512, 510,
511, 510, 511, 510, 510, 510, 510, 509, 509, 509, 510, 508, 510, 509, 510, 509, 510, 508, 509, 509, 509, 508, 510, 508, 510, 509, 510, 508, 509, 509, 509, 508, 508, 508, 510, 508, 503, 508, 507, 503,
506, 504, 508, 505, 508, 507, 510, 507, 510, 508, 510, 508, 509, 509, 507, 508, 508, 506, 510, 507, 508, 508, 509, 508, 510, 508, 511, 509, 511, 510, 513, 509, 513, 511, 514, 511, 515, 511, 513, 512,
511, 511, 511, 510, 501, 510, 496, 502, 493, 497, 492, 494, 495, 490, 491, 492, 490, 490, 493, 489, 493, 490, 498, 491, 497, 496, 497, 496, 497, 496, 499, 496, 498, 498, 496, 498, 492, 495, 491, 492,
491, 488, 490, 489, 491, 489, 491, 488, 492, 489, 495, 490, 494, 492, 494, 493, 493, 492, 491, 492, 493, 489, 495, 490, 492, 492, 493, 491, 492, 491, 491, 490, 491, 489, 490, 489, 489, 488, 489, 488,
489, 488, 487, 488, 487, 487, 490, 486, 487, 488, 487, 487, 488, 487, 487, 487, 489, 486, 491, 488, 487, 489, 487, 487, 486, 487, 487, 486, 487, 486, 487, 486, 486, 486, 487, 486, 490, 486, 487, 488,
488, 487, 490, 488, 491, 488, 491, 489, 491, 489, 492, 490, 491, 490, 489, 489, 491, 488, 489, 488, 489, 488, 491, 488, 489, 488, 489, 488, 490, 488, 489, 488, 491, 488, 490, 488, 491, 488, 493, 489,
492, 491, 492, 491, 492, 490, 494, 490, 492, 492, 492, 491, 493, 490, 492, 490, 491, 490, 491, 489, 490, 489, 490, 488, 491, 488, 493, 489, 489, 491, 488, 488, 489, 488, 490, 488, 487, 488, 487, 487,
487, 487, 487, 486, 488, 486, 489, 487, 486, 488, 487, 487, 487, 486, 487, 486, 488, 486, 489, 487, 486, 488, 489, 487, 488, 487, 487, 488, 487, 486, 488, 486, 491, 487, 489, 489, 489, 488, 489, 488,
490, 488, 490, 488, 489, 488, 488, 488, 487, 487, 485, 486, 487, 486, 487, 486, 488, 486, 489, 487, 487, 488, 487, 487, 487, 486, 491, 486, 489, 488, 486, 488, 480, 487, 477, 483, 475, 479, 470, 477,
464, 473, 462, 464, 465, 463, 463, 466, 466, 467, 455, 469, 476, 459, 479, 474, 482, 480, 482, 484, 486, 484, 489, 484, 490, 487, 491, 489, 493, 490, 495, 491, 497, 492, 500, 496, 500, 499, 500, 499,
501, 500, 503, 500, 505, 501, 506, 502, 506, 504, 505, 504, 507, 503, 508, 504, 509, 506, 515, 508, 511, 511, 510, 510, 511, 510, 510, 510, 512, 509, 510, 510, 512, 509, 510, 510, 509, 509, 509, 508,
509, 508, 511, 508, 514, 509, 513, 510, 512, 511, 512, 511, 512, 511, 513, 510, 513, 511, 512, 511, 513, 511, 512, 511, 513, 510, 514, 511, 514, 511, 515, 511, 514, 511, 512, 512, 515, 510, 514, 513,
514, 512, 515, 512, 514, 512, 513, 512, 513, 512, 514, 511, 513, 512, 514, 511, 514, 512, 513, 512, 511, 511, 511, 510, 512, 510, 513, 511, 513, 511, 514, 511, 512, 511, 517, 511, 515, 513, 514, 513,
514, 512, 515, 512, 515, 512, 515, 512, 516, 512, 513, 514, 513, 512, 512, 511, 513, 511, 514, 512, 512, 511, 512, 511, 512, 511, 511, 511, 513, 510, 512, 511, 513, 510, 511, 511, 511, 510, 512, 509,
511, 510, 510, 510, 512, 509, 512, 510, 511, 510, 512, 509, 512, 510, 510, 510, 511, 509, 511, 510, 511, 509, 511, 509, 511, 509, 510, 509, 511, 509, 510, 510, 511, 509, 510, 510, 509, 509, 510, 508,
511, 509, 510, 510, 510, 508, 510, 509, 509, 509, 509, 508, 509, 508, 508, 508, 508, 508, 510, 507, 512, 508, 514, 509, 513, 510, 515, 511, 511, 512, 514, 511, 513, 511, 514, 511, 512, 512, 513, 510,
512, 511, 516, 511, 517, 512, 518, 514, 516, 516, 518, 515, 518, 515, 515, 515, 515, 513, 512, 512, 501, 510, 499, 504, 498, 498, 495, 497, 494, 495, 494, 491, 494, 492, 489, 491, 485, 488, 484, 486,
493, 484, 499, 490, 498, 495, 498, 497, 497, 498, 497, 496, 496, 495, 494, 494, 497, 492, 496, 495, 491, 494, 492, 491, 493, 490, 494, 490, 494, 492, 492, 492, 491, 491, 491, 489, 487, 488, 488, 487,
488, 487, 488, 487, 491, 488, 494, 489, 493, 491, 495, 491, 489, 492, 490, 489, 491, 488, 491, 489, 488, 488, 486, 488, 485, 487, 485, 486, 484, 486, 486, 485, 484, 486, 487, 485, 489, 485, 488, 487,
489, 488, 488, 488, 485, 488, 491, 485, 490, 488, 489, 488, 490, 488, 488, 488, 486, 487, 488, 486, 487, 486, 488, 486, 491, 487, 490, 489, 487, 488, 486, 487, 490, 487, 489, 488, 486, 488, 492, 487,
489, 490, 488, 488, 489, 488, 488, 488, 488, 487, 487, 488, 487, 485, 490, 486, 491, 488, 492, 488, 490, 490, 489, 489, 489, 488, 488, 488, 490, 487, 494, 488, 488, 491, 489, 488, 491, 487, 488, 488,
489, 487, 488, 488, 489, 488, 490, 488, 491, 488, 491, 489, 491, 489, 490, 490, 489, 488, 490, 488, 489, 488, 489, 488, 487, 488, 483, 487, 483, 484, 486, 484, 485, 484, 490, 485, 491, 488, 487, 489,
483, 487, 483, 485, 487, 484, 487, 485, 488, 486, 488, 486, 485, 488, 487, 485, 485, 485, 490, 486, 489, 488, 483, 488, 483, 485, 479, 483, 481, 481, 483, 481, 480, 484, 480, 481, 480, 482, 480, 482,
476, 481, 474, 479, 478, 476, 476, 480, 471, 478, 460, 474, 457, 462, 449, 457, 447, 449, 449, 445, 453, 452, 454, 458, 459, 458, 460, 462, 452, 465, 458, 456, 460, 459, 460, 465, 476, 465, 471, 477,
475, 474, 467, 476, 463, 471, 471, 464, 486, 469, 498, 486, 498, 496, 498, 499, 500, 498, 502, 499, 502, 501, 504, 501, 506, 502, 507, 504, 505, 505, 508, 504, 508, 506, 510, 507, 509, 508, 507, 508,
508, 506, 507, 507, 510, 506, 509, 508, 511, 508, 512, 510, 509, 510, 510, 508, 512, 509, 514, 510, 515, 510, 515, 512, 513, 513, 514, 512, 514, 512, 513, 512, 513, 510, 513, 512, 515, 512, 515, 512,
515, 513, 519, 512, 515, 516, 515, 514, 515, 514, 512, 512, 512, 511, 512, 511, 512, 511, 512, 511, 512, 510, 512, 510, 511, 510, 512, 510, 514, 510, 513, 512, 514, 511, 515, 511, 513, 512, 513, 511,
514, 511, 514, 512, 514, 512, 514, 512, 513, 512, 518, 511, 518, 515, 517, 515, 519, 515, 515, 515, 515, 513, 514, 513, 515, 512, 514, 512, 513, 512, 513, 511, 512, 511, 513, 511, 513, 511, 512, 511,
513, 511, 513, 511, 512, 511, 510, 511, 512, 510, 512, 510, 512, 510, 512, 510, 512, 510, 512, 510, 513, 510, 513, 511, 512, 511, 511, 511, 512, 510, 512, 510, 511, 510, 512, 510, 512, 510, 513, 510,
510, 511, 511, 509, 511, 509, 510, 509, 510, 509, 511, 509, 511, 509, 511, 509, 510, 509, 510, 509, 511, 509, 512, 510, 510, 510, 510, 509, 508, 509, 508, 507, 506, 508, 510, 505, 510, 506, 511, 509,
510, 510, 511, 509, 517, 510, 515, 513, 515, 513, 517, 513, 513, 514, 516, 513, 517, 513, 518, 515, 515, 515, 517, 513, 516, 515, 517, 514, 517, 515, 516, 515, 515, 513, 512, 512, 504, 511, 501, 505,
498, 500, 496, 497, 495, 495, 494, 494, 491, 491, 492, 489, 496, 490, 497, 493, 498, 496, 498, 496, 498, 498, 498, 497, 496, 497, 495, 496, 494, 494, 493, 492, 495, 490, 493, 491, 493, 490, 493, 491,
494, 491, 494, 492, 491, 492, 492, 490, 491, 490, 490, 488, 488, 488, 488, 487, 488, 487, 488, 488, 489, 488, 488, 488, 489, 488, 490, 488, 491, 488, 491, 489, 487, 489, 487, 487, 486, 487, 488, 486,
488, 487, 488, 488, 488, 488, 489, 488, 489, 488, 490, 488, 491, 488, 490, 488, 487, 488, 489, 487, 488, 487, 486, 487, 486, 486, 487, 485, 490, 486, 487, 488, 487, 487, 491, 486, 489, 488, 488, 488,
491, 487, 489, 489, 487, 488, 491, 487, 488, 488, 487, 488, 489, 487, 486, 488, 486, 486, 488, 485, 490, 487, 488, 488, 486, 488, 486, 487, 487, 485, 485, 486, 487, 486, 487, 486, 488, 486, 488, 487,
487, 488, 488, 486, 489, 488, 488, 488, 488, 488, 487, 488, 488, 485, 489, 488, 486, 488, 484, 487, 483, 485, 484, 484, 483, 484, 484, 484, 485, 484, 484, 485, 484, 485, 484, 485, 483, 484, 485, 483,
483, 484, 481, 485, 481, 483, 480, 482, 483, 481, 481, 484, 481, 482, 483, 483, 481, 484, 481, 482, 481, 482, 483, 482, 480, 484, 480, 482, 473, 482, 469, 476, 472, 471, 482, 471, 480, 481, 478, 483,
471, 480, 475, 474, 474, 475, 465, 475, 464, 468, 464, 465, 450, 466, 440, 453, 446, 441, 444, 446, 435, 447, 431, 439, 424, 436, 413, 430, 402, 426, 390, 424, 384, 430, 378, 430, 381, 434, 391, 441,
386, 434, 411, 434, 439, 436, 439, 443, 443, 443, 449, 443, 453, 453, 459, 458, 474, 462, 479, 477, 479, 481, 482, 482, 488, 483, 494, 486, 495, 492, 497, 493, 497, 496, 498, 496, 498, 497, 501, 497,
501, 500, 504, 500, 502, 502, 504, 501, 506, 502, 510, 503, 509, 507, 508, 509, 508, 508, 509, 507, 508, 507, 509, 508, 511, 508, 510, 509, 511, 508, 510, 509, 511, 509, 514, 509, 515, 511, 515, 512,
514, 513, 510, 512, 514, 510, 516, 511, 516, 513, 516, 514, 517, 514, 518, 514, 517, 515, 517, 515, 516, 514, 516, 513, 517, 513, 516, 514, 516, 514, 515, 513, 516, 513, 515, 513, 516, 512, 515, 513,
516, 512, 518, 514, 517, 516, 515, 515, 516, 513, 515, 514, 515, 512, 515, 513, 515, 512, 516, 512, 516, 513, 516, 514, 515, 514, 520, 512, 518, 516, 517, 516, 516, 515, 516, 514, 514, 515, 515, 511,
515, 512, 515, 512, 515, 512, 514, 512, 513, 513, 519, 512, 516, 516, 515, 516, 515, 513, 515, 513, 514, 512, 515, 511, 514, 511, 514, 512, 515, 512, 514, 512, 514, 512, 515, 512, 517, 512, 515, 514,
515, 513, 515, 512, 514, 512, 514, 512, 513, 512, 515, 511, 514, 512, 514, 512, 515, 512, 515, 512, 515, 512, 515, 512, 515, 513, 513, 512, 514, 512, 514, 513, 513, 512, 513, 510, 513, 512, 514, 512,
513, 511, 514, 511, 514, 512, 513, 512, 513, 511, 513, 512, 513, 512, 514, 511, 514, 511, 513, 512, 514, 511, 514, 512, 513, 512, 513, 511, 512, 512, 513, 511, 514, 511, 514, 511, 514, 512, 515, 511,
515, 512, 516, 512, 518, 513, 518, 516, 516, 515, 516, 514, 512, 514, 512, 511, 511, 510, 511, 511, 512, 510, 512, 510, 512, 510, 511, 510, 512, 510, 514, 510, 515, 512, 516, 511, 513, 513, 512, 512,
511, 511, 510, 511, 512, 509, 509, 510, 511, 508, 509, 509, 512, 508, 508, 510, 508, 507, 511, 508, 508, 509, 508, 508, 504, 508, 505, 504, 504, 502, 504, 503, 504, 503, 504, 503, 506, 503, 506, 504,
507, 504, 510, 505, 508, 508, 507, 507, 506, 506, 504, 504, 504, 503, 503, 502, 503, 501, 502, 502, 502, 500, 503, 500, 501, 501, 502, 500, 501, 501, 501, 500, 500, 500, 501, 499, 500, 500, 499, 500,
498, 498, 500, 498, 499, 498, 500, 499, 501, 499, 500, 500, 500, 500, 500, 500, 498, 500, 499, 498, 498, 498, 499, 498, 500, 498, 500, 499, 500, 500, 501, 500, 499, 500, 500, 498, 499, 498, 499, 498,
499, 498, 498, 498, 500, 498, 498, 499, 499, 498, 499, 498, 500, 498, 500, 499, 500, 500, 503, 500, 502, 501, 501, 501, 501, 500, 501, 500, 500, 500, 502, 498, 501, 500, 501, 500, 500, 500, 501, 499,
500, 500, 501, 500, 501, 500, 501, 500, 500, 500, 500, 500, 500, 500, 499, 500, 500, 498, 501, 499, 500, 500, 500, 500, 501, 500, 502, 500, 502, 500, 501, 500, 501, 500, 500, 500, 501, 500, 500, 500,
501, 500, 500, 500, 501, 500, 501, 500, 501, 500, 502, 500, 501, 500, 500, 500, 499, 500, 500, 498, 500, 498, 500, 499, 500, 500, 500, 500, 499, 500, 500, 498, 499, 499, 512, 499, 506, 507, 501, 507,
500, 501, 498, 499, 498, 497, 495, 496, 494, 495, 493, 492, 491, 490, 492, 489, 494, 490, 497, 491, 498, 496, 497, 496, 495, 496, 497, 494, 497, 495, 495, 496, 496, 494, 498, 494, 498, 497, 499, 496,
500, 498, 502, 499, 501, 501, 501, 501, 503, 500, 503, 502, 504, 502, 504, 502, 504, 503, 505, 503, 505, 503, 506, 504, 506, 504, 506, 504, 508, 504, 508, 506, 509, 507, 509, 508, 508, 508, 508, 508,
508, 507, 509, 507, 511, 507, 512, 508, 510, 510, 516, 509, 517, 512, 517, 514, 517, 516, 518, 516, 517, 515, 518, 515, 517, 515, 517, 515, 517, 515, 518, 515, 517, 515, 518, 515, 517, 515, 517, 515,
517, 515, 518, 515, 517, 515, 517, 515, 517, 515, 519, 515, 517, 515, 518, 515, 516, 515, 515, 514, 516, 512, 515, 513, 514, 513, 515, 512, 515, 512, 515, 512, 517, 513, 517, 515, 517, 515, 519, 515,
518, 516, 519, 516, 519, 516, 518, 516, 519, 516, 518, 516, 518, 516, 519, 515, 517, 516, 518, 515, 518, 515, 518, 515, 520, 515, 520, 516, 518, 517, 517, 517, 516, 515, 516, 513, 516, 513, 516, 513,
516, 514, 515, 513, 515, 512, 516, 512, 516, 513, 518, 514, 518, 515, 518, 515, 517, 515, 517, 515, 516, 515, 516, 513, 516, 513, 516, 513, 517, 513, 516, 514, 515, 514, 516, 512, 516, 514, 516, 513,
517, 513, 517, 514, 516, 515, 515, 513, 516, 513, 515, 514, 516, 513, 516, 513, 515, 514, 517, 512, 517, 514, 515, 515, 515, 513, 515, 512, 517, 512, 515, 514, 515, 514, 516, 512, 515, 513, 515, 513,
515, 512, 515, 512, 516, 512, 515, 513, 515, 512, 515, 512, 516, 512, 515, 513, 516, 513, 515, 514, 515, 512, 515, 512, 515, 512, 515, 512, 515, 511, 513, 512, 514, 512, 515, 513, 515, 512, 515, 511,
516, 512, 516, 513, 515, 514, 516, 512, 516, 514, 517, 513, 516, 514, 515, 515, 515, 512, 515, 513, 516, 513, 516, 513, 517, 514, 517, 514, 517, 515, 518, 515, 518, 515, 521, 515, 518, 516, 516, 517,
515, 515, 514, 512, 515, 512, 515, 512, 515, 513, 516, 513, 515, 514, 515, 512, 515, 512, 521, 512, 517, 516, 516, 515, 514, 515, 514, 513, 513, 511, 514, 512, 512, 512, 512, 511, 510, 511, 510, 510,
510, 509, 512, 509, 512, 510, 512, 510, 510, 510, 508, 509, 509, 507, 509, 508, 509, 508, 508, 508, 509, 508, 508, 508, 508, 508, 511, 507, 509, 509, 508, 508, 506, 508, 506, 505, 507, 504, 507, 504,
507, 506, 508, 506, 507, 507, 508, 506, 508, 507, 509, 507, 508, 507, 506, 507, 507, 505, 506, 505, 505, 504, 505, 503, 504, 504, 504, 503, 505, 503, 504, 504, 505, 503, 505, 503, 505, 504, 505, 504,
504, 504, 506, 503, 505, 504, 504, 504, 505, 503, 504, 503, 505, 503, 506, 504, 506, 504, 506, 504, 505, 504, 504, 504, 504, 503, 505, 503, 504, 504, 504, 503, 505, 503, 505, 503, 504, 504, 504, 503,
505, 503, 507, 503, 507, 505, 507, 506, 505, 507, 504, 505, 505, 503, 505, 504, 505, 504, 505, 504, 505, 504, 505, 504, 505, 504, 506, 504, 505, 504, 504, 504, 503, 503, 503, 502, 501, 502, 500, 500,
500, 498, 499, 499, 500, 498, 500, 498, 500, 500, 506, 500, 503, 503, 500, 503, 498, 499, 498, 497, 498, 496, 498, 496, 496, 496, 495, 495, 493, 494, 493, 491, 493, 490, 494, 490, 494, 492, 494, 492,
494, 492, 493, 492, 494, 492, 494, 491, 497, 492, 496, 495, 495, 495, 498, 494, 496, 496, 498, 495, 498, 496, 498, 497, 498, 497, 498, 497, 498, 496, 499, 497, 498, 497, 499, 497, 499, 498, 498, 498,
499, 498, 500, 498, 499, 499, 499, 499, 499, 499, 499, 498, 500, 498, 500, 499, 500, 500, 500, 500, 501, 500, 500, 500, 502, 500, 506, 500, 509, 504, 511, 507, 511, 509, 512, 510, 512, 510, 511, 510,
512, 509, 510, 510, 511, 509, 511, 510, 511, 509, 512, 509, 509, 510, 511, 508, 511, 510, 511, 509, 511, 509, 510, 509, 512, 509, 512, 510, 513, 511, 513, 511, 513, 511, 513, 511, 512, 511, 513, 511,
512, 511, 513, 510, 512, 511, 511, 510, 511, 509, 511, 510, 513, 509, 514, 511, 514, 511]

data_lable=[]
data_pred=[]
for i in range(0, len(data)//2):
	data_lable.append(data[2*i]-500)
	data_pred.append(data[2*i+1]-500)
	
fig = plt.figure()
plt.plot(range(len(data_lable)), data_lable)
plt.plot(range(len(data_lable)), data_pred)
# plt.show()
fig.savefig("xx.png")