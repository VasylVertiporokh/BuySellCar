//
//  ImageZoomCell.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 08/08/2023.
//

import UIKit
import SnapKit
import Kingfisher

final class ImageZoomCell: UICollectionViewCell {
    // MARK: - Subviews
    private var scrollView: UIScrollView!
    private var imageView: UIImageView!
    
    // MARK: - Private properties
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = Constant.numberOfTapsRequired
        return zoomingTap
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension ImageZoomCell {
    func set(imageStringUrl: String?) {
        imageStringUrl.loadImageDataFromString { [weak self] imageData in
            guard let self = self,
                  let imageData = imageData else {
                return
            }
            self.imageView = UIImageView(image: .init(data: imageData))
            self.scrollView.addSubview(imageView)
            self.configurateFor(imageSize:imageView.image?.size)
            self.centerImage()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageZoomCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}

// MARK: - Private extension
private extension ImageZoomCell {
    func initialSetup() {
        setupLayout()
        setupUI()
        conformToDelegates()
    }
    
    func setupLayout() {
        // scrollView
        scrollView = UIScrollView(frame: contentView.bounds)
        scrollView.backgroundColor = .black
        contentView.backgroundColor = .black
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentView) }
    }
    
    func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        
    }
    
    func configurateFor(imageSize: CGSize?) {
        guard let imageSize = imageSize else {
            return
        }
        scrollView.contentSize = imageSize
        setCurrentMaxandMinZoomScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
        
    }
    
    func setCurrentMaxandMinZoomScale() {
        let boundsSize = scrollView.bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = Constant.maxScale
        if minScale < 0.1 {
            maxScale = 0.45
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.8
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
    }
    
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / Constant.frameToCenterKoef
        } else {
            frameToCenter.origin.x = .zero
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / Constant.frameToCenterKoef
        } else {
            frameToCenter.origin.y = .zero
        }
        
        imageView.frame = frameToCenter
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        scrollView.zoom(to: zoomRect, animated: animated)
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / Constant.frameToCenterKoef)
        zoomRect.origin.y = center.y - (zoomRect.size.height / Constant.frameToCenterKoef)
        return zoomRect
    }
    
    func conformToDelegates() {
        scrollView.delegate = self
    }
}

// MARK: - Actions
private extension ImageZoomCell {
    @objc
    func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
}

// MARK: - Constant
private enum Constant {
    static let numberOfTapsRequired: Int = 2
    static let maxScale: CGFloat = 1.0
    static let frameToCenterKoef: CGFloat = 2.0
}
