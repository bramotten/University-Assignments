function twoD = threeToTwo(threeD, proj)
threeD = [threeD(1), threeD(2), threeD(3), 1]';
twoD = proj * threeD;
twoD = twoD / twoD(3);