//
//  PhotosViewController.swift
//  Navigation


import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    //5 hw
    //let imagePublisherFacade = ImagePublisherFacade()
    
    // массив для загрузки полученных картинок
    //5 hw
    var photos: [UIImage] = []
    var processedPhotos: [UIImage] = []
    var counter = 0
    
    // для имитации ошибки
    let photos_error = [UIImage]()
    
    private var timer: Timer?
    
    lazy var profile: [Profile] = Profile.make()
    
    let spacing = 8.0
    
    enum CellID: String {
        case base = "ViewCell_ReuseID"
    }
    private let timeLabel = UILabel()
    private let collectionView: UICollectionView = {
        let  viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: CellID.base.rawValue
        )
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchImage()
        addProcessImagesOnThread()
        //подготовка перед отображением
        //imagePublisherFacade.subscribe(self) //подписка
        //imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: 21, userImages: photos) //загрузка с задержкой
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //завершающие операции,когда представление исчезло с экрана
        //imagePublisherFacade.removeSubscription(for: self) //удаление подписки
        //imagePublisherFacade.rechargeImageLibrary() //очистка библиотеки загруженных фото
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        view.backgroundColor = .white
        //загрузка своих фото в массив
        //5 hw
        
        for i in 0...profile.count-1 {
            photos.append(UIImage(imageLiteralResourceName: profile[i].img))
        }

        fetchImage()
        setupCollectionView()
        setupLayouts()

    }
    
    //MARK: - ОБРАБОТКА ОШИБОК - пример
    
    private func fetchImage() {

        let networkService = NetworkService(photosViewController: self)
        do {
            try networkService.getPhotos(arrayPhotos: photos)
            // имитация ошибки
            //try networkService.getPhotos(arrayPhotos: photos_error)
        } catch ApiError.notFound {
            print(photos.count)
            showAlert(title: "Фото не загружены", message: "Попробуйте еще раз")
        } catch ApiError.invalidInput {
            showAlert(title: "Фото не найдены", message: "Попробуйте еще раз")
        } catch ApiError.networkError {
            showAlert(title: "Error", message: "Неизвестная ошибка.Попробуйте еще раз")
        }  catch {
            print("default")
        }

    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }

    //MARK: - Комментарий к заданию 10 -
    /*
    В методе addProcessImagesOnThread() вместе с реализацией задачи из 8-го задания добавлен таймер для визуализации времени ожидания обработки фото. Таймер исчезает, когда коллекция фото отображается на экране
    */
    //MARK: - -
    
    func addProcessImagesOnThread() {
        let start = DispatchTime.now()
        let method = ImageProcessor()
        let networkService = NetworkService(photosViewController: self)
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                self.counter += 1
                self.timeLabel.text = "waiting \(self.counter)"
            })
            timer?.tolerance = 0.3
          /*
            // * если папка photos пуста, то дальнейшее выполнение бессмысленно
            guard !photos.isEmpty else {
                preconditionFailure("фото отсутствуют")
            }
          */
            method.processImagesOnThread(sourceImages: photos, filter: .chrome, qos: .default) { [weak self] processedImage in
                
                let queue = DispatchQueue.global()
                
                queue.async {
                    
                    self?.processedPhotos = processedImage.map { UIImage(cgImage: $0!) }
                    let end = DispatchTime.now()
                    let answer = end.uptimeNanoseconds - start.uptimeNanoseconds
                    let interval = Double(answer) / 1000000000
                    print("обработка изображений занимает - \(interval) секунд")

                }
                
                DispatchQueue.main.async {
                    
                    // Задание 11 - задача 3
                    networkService.chanchedPhoto(array: self?.processedPhotos ?? self!.photos) { result in
                        switch result {
                        case .success(_):
                            self?.collectionView.reloadData()
                            print("ok")
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    self?.timer?.invalidate()
                    self?.timer = nil
                    self?.timeLabel.text = ""
                
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
        }


    }
    // MARK: - обработка изображений занимает:
    // qos: .default - 44.505652215 секунд
    // qos: .background - 171.554239968 секунд
    // qos: .userInitiated - 37.60918313 секунд
    // qos: .userInteractive - 43.117960946 секунд
    // qos: .utility - 85.908131826 секунд
    
    // .userInitiated - высший приоритет для задач по запросу пользователя, быстрое выполнение
    
   /*
    private func loadingWithTimer() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                // какой-то код
            })
            self.timer?.tolerance = 0.3
            
            guard let timer = timer else { return }
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run()
        }

    }
    */

    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(timeLabel)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        let sefeAreaGuide = view.safeAreaLayoutGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            timeLabel.centerXAnchor.constraint(equalTo: sefeAreaGuide.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: sefeAreaGuide.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: sefeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sefeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sefeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sefeAreaGuide.trailingAnchor)
            
        ])
    }
}

extension PhotosViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout //ImageLibrarySubscriber
{
    
    
    //5 hw
    /*
    func receive(images: [UIImage]) {
        self.photos = images //загружаем в массив полученные фото
        self.collectionView.reloadData() //обновление
    
    }
    */
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        //5 hw
        //photos.count // количество ячеек в секции
        //profile.count //как было
        
        processedPhotos.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.base.rawValue,
            for: indexPath) as! PhotosCollectionViewCell
                
        //let prof = profile[indexPath.row]
        //cell.setup(with: prof)
        //5 hw
        cell.profileImageView.image = processedPhotos[indexPath.row]  //размещение картинок

        return cell
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width
        let numberOfColumns: CGFloat = 3.5
        let cellWidth = width / numberOfColumns

        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }
}


