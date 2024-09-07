//
//  MyEvaluationTableViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/7/24.
//

import UIKit

final class MyEvaluationTableViewCell: UITableViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: MyEvaluationTableViewCell.self)

    var model: EvaluatedRestaurant? { didSet { bind() }}

    private var restaurantImageView = UIImageView()
    private var restaurantNameButton = UIButton()
    private var ratingStarView = KuStarRatingImageView()
    private var commentLabel = UILabel()
    private var evaluationTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var lineView = UIView()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
        setupStyle()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyEvaluationTableViewCell {
    
    private func setupLayout() {
        let restaurantInfoView = UIStackView()
        restaurantInfoView.axis = .vertical
        restaurantInfoView.spacing = 8
        restaurantInfoView.distribution = .fillProportionally
        restaurantInfoView.alignment = .leading
        restaurantInfoView.addArrangedSubview(restaurantNameButton)
        restaurantInfoView.addArrangedSubview(ratingStarView)
        
        let topHStackView = UIStackView()
        topHStackView.axis = .horizontal
        topHStackView.spacing = 12
        topHStackView.distribution = .fillProportionally
        topHStackView.alignment = .center
        topHStackView.addArrangedSubview(restaurantImageView)
        topHStackView.addArrangedSubview(restaurantInfoView)
        restaurantImageView.autolayout([.width(51), .height(51)])
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.distribution = .fillProportionally
        mainStackView.addArrangedSubview(topHStackView)
        mainStackView.addArrangedSubview(commentLabel)
        mainStackView.addArrangedSubview(evaluationTagCollectionView)
        mainStackView.addArrangedSubview(lineView)
        lineView.autolayout([.widthEqual(to: mainStackView, constant: 0), .height(1)])

        addSubview(mainStackView, autoLayout: [.fillY(8), .fillX(21)])
    }
    
    private func setupStyle() {
        commentLabel.font = .Pretendard.regular14
        commentLabel.textColor = .Sementic.gray800
        lineView.backgroundColor = .Sementic.gray75
    }
}

extension MyEvaluationTableViewCell {
    
    private func bind() {
        loadImage()
        setupRestaurantNameButton()
        ratingStarView.update(rating: Double(model?.evaluationStore ?? 0), width: 20)
        commentLabel.text = model?.restaurantComment
        if let model = model, let scores = model.evaluationItemScores, !scores.isEmpty {
            collectionViewHeightConstraint = evaluationTagCollectionView.heightAnchor.constraint(equalToConstant: 29)
            collectionViewHeightConstraint?.isActive = true
        }
    }
    
    private func setupRestaurantNameButton() {
        var buttonConfig = UIButton.Configuration.plain()
        let buttonTitle = model?.restaurantName ?? ""
        let attributedTitle = AttributedString(buttonTitle, attributes: AttributeContainer([
            .font: UIFont.Pretendard.semiBold16,
            .foregroundColor: UIColor.Sementic.gray800 ?? .gray
        ]))
        let image = UIImage(named: "icon_chevron_right")
        buttonConfig.image = image
        buttonConfig.imagePadding = 4
        buttonConfig.imagePlacement = .trailing
        buttonConfig.attributedTitle = attributedTitle
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        restaurantNameButton.configuration = buttonConfig
    }
    
    private func loadImage() {
        if let urlString = model?.restaurantImgURL,
           let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url, targetWidth: 55, defaultImage: UIImage(named: "img_dummy")) { [weak self] image in
                DispatchQueue.main.async {
                    self?.restaurantImageView.image = image
                }
            }
        } else {
            restaurantImageView.image = UIImage(named: "img_dummy")
        }
    }
}

extension MyEvaluationTableViewCell {
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        evaluationTagCollectionView.setCollectionViewLayout(layout, animated: false)
        evaluationTagCollectionView.delegate = self
        evaluationTagCollectionView.dataSource = self
        evaluationTagCollectionView.registerCell(ofType: EvaluationStoreCollectionViewCell.self)
        evaluationTagCollectionView.showsHorizontalScrollIndicator = false
        evaluationTagCollectionView.isScrollEnabled = false
    }
}

extension MyEvaluationTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = model, let itemScores = model.evaluationItemScores {
            let text = itemScores[indexPath.row]
            let textWidth = (text as NSString).boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 29),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: UIFont.Pretendard.regular14],
                context: nil
            ).width
            
            return CGSize(width: textWidth + 16, height: 29)
        } else {
            return CGSize.zero
        }
    }
}

extension MyEvaluationTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.evaluationItemScores?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EvaluationStoreCollectionViewCell.reuseIdentifier, for: indexPath) as? EvaluationStoreCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let text = model?.evaluationItemScores?[indexPath.row] {
            cell.update(text: text)
        }
        
        return cell
    }
}

fileprivate final class EvaluationStoreCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    static var reuseIdentifier = String(describing: EvaluationStoreCollectionViewCell.self)
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label, autoLayout: [.fill(0)])
        label.textAlignment = .center
        label.font = .Pretendard.regular14
        label.textColor = .Sementic.gray300
        contentView.layer.cornerRadius = 15
        contentView.layer.cornerCurve = .continuous
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.Sementic.gray300?.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func update(text: String) {
        label.text = text
    }
}
