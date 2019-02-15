//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Mark Meretzky on 2/12/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;
import SafariServices; //p. 670
import MessageUI;      //p. 679

class ViewController: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate, //p. 674
    MFMailComposeViewControllerDelegate,                             //p. 680
    MFMessageComposeViewControllerDelegate {                         //p. 681

    @IBOutlet weak var imageView: UIImageView!;   //p. 667
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {   //p. 667
        switch sender.selectedSegmentIndex {
        case 0:
            shareButtonTapped(sender);
        case 1:
            safariButtonTapped(sender);
        case 2:
            photosButtonTapped(sender);
        case 3:
            emailButtonTapped(sender);
        case 4:
            textButtonTapped(sender);
        default:
            fatalError("segmented control has no segment number \(sender.selectedSegmentIndex)");
        }
    }
    
    func shareButtonTapped(_ sender: UISegmentedControl) {   //p. 668
        guard let image: UIImage = imageView.image else {
            return;
        }
        print("shareButtonTapped");
        
        let activityController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil);
        activityController.popoverPresentationController?.sourceView = sender;
    
        present(activityController, animated: true);
        sender.selectedSegmentIndex = -1;
    }
    
    func safariButtonTapped(_ sender: UISegmentedControl) {   //pp. 670-671
        guard let url: URL = URL(string: "http://www.nyt.com/") else {
            fatalError("could not create url from string \"http://www.nyt.com/\"");
        }

        let safariViewController: SFSafariViewController = SFSafariViewController(url: url);
        present(safariViewController, animated: true);
        sender.selectedSegmentIndex = -1;
    }
    
    func photosButtonTapped(_ sender: UISegmentedControl) {   //pp. 672-673
        let imagePicker: UIImagePickerController = UIImagePickerController();   //p. 674
        imagePicker.delegate = self;
        
        let alertController: UIAlertController = UIAlertController(
            title: "Choose Image Source",
            message: "Where do you want to get an image from?",
            preferredStyle: .actionSheet
        );
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {   //p. 675
            let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) {(action: UIAlertAction) in
                imagePicker.sourceType = .camera;
                self.present(imagePicker, animated: true);
            }
            alertController.addAction(cameraAction);
        }

        if UIImagePickerController.isSourceTypeAvailable (.photoLibrary) {   //p. 676
            let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) {(action: UIAlertAction) in
                imagePicker.sourceType = .photoLibrary;
                print("type(of: self) = \(type(of: self))");
                self.present(imagePicker, animated: true);   //self is the ViewController, not the UIAlertController
            }
            alertController.addAction(photoLibraryAction);
        }
        
        let breakinAction: UIAlertAction = UIAlertAction(title: "Break into Metropolitan Museum of Art", style: .destructive) {
            print("User selected \($0.title!) action.");
        }
        alertController.addAction(breakinAction);
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {
            print("User selected \($0.title!) action.");
        }
        alertController.addAction(cancelAction);
        
        alertController.popoverPresentationController?.sourceView = sender;
        present(alertController, animated: true);
        sender.selectedSegmentIndex = -1;
    }
    
    func emailButtonTapped(_ sender: UISegmentedControl) {
        guard MFMailComposeViewController.canSendMail() else {   //p. 679
            print("Can not send mail");
            return;
        }
        
        let mailComposer: MFMailComposeViewController = MFMailComposeViewController();   //p. 680
        mailComposer.mailComposeDelegate = self;
        mailComposer.setToRecipients(["example@example.com"]);
        mailComposer.setSubject("Look at this");
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false);
        present(mailComposer, animated: true);   //p. 681
        sender.selectedSegmentIndex = -1;
    }
    
    func textButtonTapped(_ sender: UISegmentedControl) {   //p. 681
        guard MFMessageComposeViewController.canSendText() else {
            print("Can not send text");
            return;
        }
        
        let textComposer: MFMessageComposeViewController = MFMessageComposeViewController();
        textComposer.messageComposeDelegate = self;
        textComposer.recipients = ["4085551212"]
        textComposer.body = "Hello from California!"
        present(textComposer, animated: true);
        sender.selectedSegmentIndex = -1;
    }
    
    // MARK: - UIImagePickerControllerDelegate, p. 678
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage;
            dismiss(animated: true);   //Dismiss the UIImagePickerController.
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate, p. 681

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("mailComposeController(_:didFinishWith:error:): \(error!)");
        }
        dismiss(animated: true);
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate, p. 681
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        let results: [String] = ["cancelled", "sent", "failed"];
        print("result = \(results[result.rawValue])");
        controller.dismiss(animated: true);
    }
    
}
