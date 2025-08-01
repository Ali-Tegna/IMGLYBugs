//
//  VideoExportView.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
import _AVKit_SwiftUI
import AVFoundation
import IMGLYEngine
import IMGLYVideoEditor
import SwiftUI

struct VideoEditorView: View {
	@Environment(\.router) var router;
	@Environment(\.presentationMode) var presentationMode
	@State var videoUrl: URL
	@State var engine: Engine?
	@State private var showCancelModal = false
	@State private var videoExportURL: URL? = nil
	@State var showDraftPopup = false
	@State var isSavingDraft = false
	@State var showDraftToast = false
	
	var cameraAction: Dock.Context.To<Void> = { $0.eventHandler.send(.addFromSystemCamera()) }
	
	var textAction: Dock.Context.To<Void> = { context in
		context.eventHandler.send(.openSheet(type: .libraryAdd(style: .addAsset(detent: .imgly.medium)) {
			context.assetLibrary.textTab
		}))
	}
	
	var voiceoverAction: Dock.Context.To<Void> = { $0.eventHandler.send(.openSheet(type: .voiceover())) }
	
	var body: some View {
		ZStack {
			VideoEditor(Secrets.Settings)
				.preferredColorScheme(.dark)
				.imgly.onCreate { engine in
					self.engine = engine
					try await engine.addDefaultAssetSources()
					try await engine.addDemoAssetSources(
						exclude: [],
						sceneMode: .video,
						withUploadAssetSources: true
					)
					try await engine.asset.addSource(TextAssetSource(engine: engine))
					let scene = try await engine.scene.create(fromVideo: videoUrl)
					// scene.getZoom
					let page = try engine.block.find(byType: .page).first!
					_ = try engine.block.addTopSafeArea(for: page, to: scene)
					_ = try engine.block.addBottomSafeArea(for: page, to: scene)
				}
				.imgly.navigationBarItems { _ in
					NavigationBar.ItemGroup(placement: .topBarLeading) {
						NavigationBar.Button(id: "customBack") { _ in
							showDraftPopup = true
						} label: { _ in
							Image(systemName: "chevron.backward")
								.foregroundStyle(Color.white)
						}
					}
					// Custom navigation bar title
					NavigationBar.ItemGroup(placement: .principal) {
						NavigationBar.Button(
							id: "navigationBar.title"
						) { _ in
						} label: { _ in
							Text("Edit Video")
								.font(
									Font.custom("Inter", size: 16)
										.weight(.semibold)
								)
								.foregroundColor(Color.white)
						} isEnabled: { _ in
							false
						} isVisible: { _ in
							true
						}
					}
					NavigationBar.ItemGroup(placement: .topBarTrailing) {
						NavigationBar.Buttons.export(label: { _ in
							Text("Save")
								.font(
									Font.custom("Inter", size: 14)
										.weight(.bold)
								)
								.foregroundStyle(Color.blue)
						})
					}
				}
				.imgly.dockItems { context in
					DockerItem(
						title: "Camera",
						icon: "camera"
					) {
						do {
							try cameraAction(context)
						} catch {
							print("Failed to load camera sheet: \(error)")
						}
					}
					DockerItem(
						title: "Text",
						icon: "camera"
					) {
						do {
							try textAction(context)
						} catch {
							print("Failed to load text sheet: \(error)")
						}
					}
					DockerItem(
						title: "Templates",
						icon: "camera"
					) {}
					DockerItem(
						title: "Voiceover",
						icon: "camera"
					) {
						do {
							try voiceoverAction(context)
						} catch {
							print("Failed to load voicerover sheet: \(error)")
						}
					}
				}
				.imgly.onExport { engine, eventHandler in
					do {
						guard let page = try engine.scene.getCurrentPage() else {
							throw CallbackError.noPage
						}
						
						let mimeType: MIMEType = .mp4
						let options = VideoExportOptions(
							videoBitrate: 1_000_000,
							audioBitrate: 64_000,
							framerate: 24,
							targetWidth: 1280,
							targetHeight: 720
						)
						eventHandler.send(.exportProgress(.relative(.zero)))
						
						let stream = try await engine.block.exportVideo(page,
						                                                mimeType: mimeType,
						                                                options: options)
						
						for try await event in stream {
							try Task.checkCancellation()
							
							switch event {
							case let .progress(_, encoded, total):
								let pct = Float(encoded) / Float(total)
								eventHandler.send(.exportProgress(.relative(pct)))
								
							case let .finished(videoData):
								let trimmedURL = FileManager.default.temporaryDirectory
									.appendingPathComponent(UUID().uuidString,
									                        conformingTo: mimeType.uniformType)
								try videoData.write(to: trimmedURL, options: [.atomic])
								
								eventHandler.send(.exportCompleted {
									DispatchQueue.main.async {
										do {
											let uuid = UUID().uuidString
											let ext = trimmedURL.pathExtension
											let uniqueFilename = "\(uuid).\(ext)"
											let docs = FileManager.default
												.urls(for: .documentDirectory, in: .userDomainMask)[0]
											let uniqueURL = docs.appendingPathComponent(uniqueFilename)
											
											if FileManager.default.fileExists(atPath: uniqueURL.path) {
												try FileManager.default.removeItem(at: uniqueURL)
											}
											try FileManager.default.moveItem(at: trimmedURL, to: uniqueURL)
											
											videoExportURL = uniqueURL
											// usually we pass this URL further but for this example we don't need to
											router.navigateToNextPage()
										} catch {
											print("Error saving trimmed video:", error)
										}
									}
								})
								return
							}
						}
						
						try Task.checkCancellation()
						throw CallbackError.couldNotExport
						
					} catch is CancellationError {
						eventHandler.send(.closeSheet)
						return
						
					} catch {
						print("Error exporting trimmed video:", error)
					}
				}
				.toolbarBackground(.visible, for: .navigationBar)
				.toolbarBackground(Color.black, for: .navigationBar)
		}
		.disabled(isSavingDraft)
	}
}
